defmodule MidiProto.Firmata.PinStateResponse do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct pin: nil, mode: nil, state: nil

  @moduledoc """
  Represents a Firmata pin state response implemented using a MIDI SysEx message.
  """

  @type pin_mode ::
          :input
          | :output
          | :analog
          | :pwm
          | :servo
          | :i2c
          | :onewire
          | :stepper
          | :encoder
          | :ignore
  @type t :: %PinStateResponse{pin: MidiProto.seven_bit_int(), mode: pin_mode, state: binary}

  @doc """
  Initialise a new `PinStateResponse` struct.
  """
  @spec init(MidiProto.seven_bit_int(), pin_mode, binary) :: t
  def init(pin, mode, state)
      when is_seven_bit_int(pin) and
             mode in ~w[input output analog pwm servo i2c onewire stepper encoder ignore]a and
             is_binary(state),
      do: %PinStateResponse{pin: pin, mode: mode, state: state}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.PinStateResponse do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.MessagePredicateGenerator

  def encode(%{pin: pin, mode: mode, state: state}) when is_binary(state) do
    mode = mode_to_byte(mode)

    SystemExclusive.init(0x6E, <<0::integer-size(1), pin::integer-size(7), mode, state::binary>>)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)

  defp mode_to_byte(:input), do: 0x00
  defp mode_to_byte(:output), do: 0x01
  defp mode_to_byte(:analog), do: 0x02
  defp mode_to_byte(:pwm), do: 0x03
  defp mode_to_byte(:servo), do: 0x04
  defp mode_to_byte(:shift), do: 0x05
  defp mode_to_byte(:i2c), do: 0x06
  defp mode_to_byte(:onewire), do: 0x07
  defp mode_to_byte(:stepper), do: 0x08
  defp mode_to_byte(:encoder), do: 0x09
  defp mode_to_byte(:ignore), do: 0x7F
end
