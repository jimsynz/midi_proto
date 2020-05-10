defmodule MidiProto.Firmata do
  alias MidiProto.Firmata.{
    AnalogMappingQuery,
    AnalogMappingResponse,
    CapabilityQuery,
    CapabilityResponse,
    ExtendedAnalog,
    FirmwareQuery,
    FirmwareResponse,
    PinStateQuery,
    PinStateResponse,
    SamplingInterval,
    StringData
  }

  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Firmata.String
  use Bitwise

  # Firmata message types
  @type t ::
          AnalogMappingQuery
          | AnalogMappingResponse
          | CapabilityQuery
          | CapabilityResponse
          | ExtendedAnalog
          | FirmwareQuery
          | FirmwareResponse
          | PinStateQuery
          | PinStateResponse
          | SamplingInterval
          | StringData

  @moduledoc """
  This module converts incoming MIDI messages into Firmata messages if possible.
  """

  @doc """
  Given a MIDI message struct, convert it to it's equivalent Firmata message.
  """
  @spec convert(Message.t()) :: {:ok, Firmata.t()} | {:error, reason :: any}
  def convert(%SystemExclusive{vendor_id: 0x69, payload: ""}),
    do: {:ok, AnalogMappingQuery.init()}

  def convert(%SystemExclusive{vendor_id: 0x68, payload: payload}) when byte_size(payload) > 0,
    do: {:ok, AnalogMappingResponse.init(decode_analog_pin_mappings([], payload))}

  def convert(%SystemExclusive{vendor_id: 0x6B, payload: ""}),
    do: {:ok, CapabilityQuery.init()}

  def convert(%SystemExclusive{vendor_id: 0x6B, payload: payload}) when byte_size(payload) > 0,
    do: {:ok, CapabilityResponse.init(decode_capabilities([], payload))}

  def convert(%SystemExclusive{
        vendor_id: 0x6D,
        payload: <<0::integer-size(1), pin::integer-size(7)>>
      }),
      do: {:ok, PinStateQuery.init(pin)}

  def convert(%SystemExclusive{
        vendor_id: 0x6E,
        payload: <<0::integer-size(1), pin::integer-size(7), mode, state::binary>>
      }) do
    mode = decode_pin_mode(mode)
    {:ok, PinStateResponse.init(pin, mode, state)}
  end

  def convert(%SystemExclusive{
        vendor_id: 0x6F,
        payload: <<0::integer-size(1), pin::integer-size(7), bytes::binary>>
      }),
      do: {:ok, ExtendedAnalog.init(pin, bytes)}

  def convert(%SystemExclusive{vendor_id: 0x79, payload: ""}), do: {:ok, FirmwareQuery.init()}

  def convert(%SystemExclusive{
        vendor_id: 0x79,
        payload:
          <<0::integer-size(1), major_version::integer-size(7), 0::integer-size(1),
            minor_version::integer-size(7), name::binary>>
      }) do
    with {:ok, name} <- decode(name),
         do: {:ok, FirmwareResponse.init(major_version, minor_version, name)}
  end

  def convert(%SystemExclusive{vendor_id: 0x71, payload: string}) do
    with {:ok, decoded} <- decode(string),
         do: {:ok, StringData.init(decoded)}
  end

  def convert(%SystemExclusive{vendor_id: 0x7A, payload: <<lsb, msb>>}),
    do: {:ok, SamplingInterval.init(lsb + (msb <<< 7))}

  def convert(_), do: {:error, "Unknown MIDI message"}

  defp decode_analog_pin_mappings(result, ""), do: Enum.reverse(result)

  defp decode_analog_pin_mappings(result, <<0x7F, rest::binary>>),
    do: decode_analog_pin_mappings([:not_supported | result], rest)

  defp decode_analog_pin_mappings(
         result,
         <<0::integer-size(1), pin::integer-size(7), rest::binary>>
       ),
       do: decode_analog_pin_mappings([pin | result], rest)

  defp decode_capabilities(result, ""), do: Enum.reverse(result)

  defp decode_capabilities(result, <<0x7F, rest::binary>>),
    do: decode_capabilities([:unsupported | result], rest)

  defp decode_capabilities(result, <<byte0, byte1, 0x7F, rest::binary>>),
    do: decode_capabilities([decode_capability(byte0, byte1) | result], rest)

  defp decode_capabilities(result, <<byte0, byte1>>),
    do: decode_capabilities([decode_capability(byte0, byte1) | result], "")

  defp decode_capability(0x00, 0x01), do: :digital_input
  defp decode_capability(0x00, res), do: {:digital_input, res}
  defp decode_capability(0x01, 0x01), do: :digital_output
  defp decode_capability(0x01, res), do: {:digital_output, res}
  defp decode_capability(0x02, res), do: {:analog_input, res}
  defp decode_capability(0x03, res), do: {:pwm, res}
  defp decode_capability(0x04, res), do: {:servo, res}
  defp decode_capability(0x05, _), do: :shift
  defp decode_capability(0x06, _), do: :i2c
  defp decode_capability(0x07, _), do: :onewire
  defp decode_capability(0x08, res), do: {:stepper, res}
  defp decode_capability(0x09, _), do: :encoder
  defp decode_capability(0x0A, 0x00), do: {:serial, :rx0}
  defp decode_capability(0x0A, 0x01), do: {:serial, :tx0}
  defp decode_capability(0x0A, 0x02), do: {:serial, :rx1}
  defp decode_capability(0x0A, 0x03), do: {:serial, :tx1}
  defp decode_capability(0x0A, 0x04), do: {:serial, :rx2}
  defp decode_capability(0x0A, 0x05), do: {:serial, :tx2}
  defp decode_capability(0x0A, 0x06), do: {:serial, :rx3}
  defp decode_capability(0x0A, 0x07), do: {:serial, :tx3}
  defp decode_capability(0x0A, 0x08), do: {:serial, :rx4}
  defp decode_capability(0x0A, 0x09), do: {:serial, :tx4}
  defp decode_capability(0x0A, 0x0A), do: {:serial, :rx5}
  defp decode_capability(0x0A, 0x0B), do: {:serial, :tx5}
  defp decode_capability(0x0A, 0x0C), do: {:serial, :rx6}
  defp decode_capability(0x0A, 0x0D), do: {:serial, :tx6}
  defp decode_capability(0x0A, 0x0E), do: {:serial, :rx7}
  defp decode_capability(0x0A, 0x0F), do: {:serial, :tx7}
  defp decode_capability(0x0B, _), do: :input_pullup

  defp decode_pin_mode(0x00), do: :input
  defp decode_pin_mode(0x01), do: :output
  defp decode_pin_mode(0x02), do: :analog
  defp decode_pin_mode(0x03), do: :pwm
  defp decode_pin_mode(0x04), do: :servo
  defp decode_pin_mode(0x05), do: :shift
  defp decode_pin_mode(0x06), do: :i2c
  defp decode_pin_mode(0x07), do: :onewire
  defp decode_pin_mode(0x08), do: :stepper
  defp decode_pin_mode(0x09), do: :encoder
  defp decode_pin_mode(0x7F), do: :ignore
end
