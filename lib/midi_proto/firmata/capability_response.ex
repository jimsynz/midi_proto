defmodule MidiProto.Firmata.CapabilityResponse do
  alias __MODULE__
  defstruct capabilities: []

  @moduledoc """
  Represents a Firmata capability response implemented using a MIDI SysEx message.
  """

  @type pin_mode ::
          :unsupported
          | :digital_input
          | :digital_output
          | :analog_input
          | :pwm
          | :servo
          | :shift
          | :i2c
          | :onewire
          | :stepper
          | :encoder
          | :serial
          | :input_pullup
  @type pin_resolution :: non_neg_integer

  @type t :: %CapabilityResponse{capabilities: [{pin_mode, pin_resolution} | pin_mode]}

  @doc """
  Initialise a new `CapabilityResponse` struct.
  """
  @spec init([{pin_mode, pin_resolution} | pin_mode]) :: t
  def init(capabilities) when is_list(capabilities) and length(capabilities) > 0,
    do: %CapabilityResponse{capabilities: capabilities}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.CapabilityResponse do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{capabilities: capabilities}) do
    payload =
      capabilities
      |> Enum.map(fn
        :unsupported -> <<>>
        :digital_input -> <<0x00, 0x01>>
        :digital_output -> <<0x01, 0x01>>
        :shift -> <<0x05, 0x00>>
        :i2c -> <<0x06, 0x00>>
        :onewire -> <<0x07, 0x00>>
        :encoder -> <<0x09, 0x00>>
        :input_pullup -> <<0x0B, 0x01>>
        {:digital_input, i} -> <<0x00, 0::integer-size(1), i::integer-size(7)>>
        {:digital_output, i} -> <<0x01, 0::integer-size(1), i::integer-size(7)>>
        {:analog_input, i} -> <<0x02, 0::integer-size(1), i::integer-size(7)>>
        {:pwm, i} -> <<0x03, 0::integer-size(1), i::integer-size(7)>>
        {:servo, i} -> <<0x04, 0::integer-size(1), i::integer-size(7)>>
        {:stepper, i} -> <<0x08, 0::integer-size(1), i::integer-size(7)>>
        {:input_pullup, i} -> <<0x0B, 0::integer-size(1), i::integer-size(7)>>
        {:serial, :rx0} -> <<0x0A, 0x00>>
        {:serial, :tx0} -> <<0x0A, 0x01>>
        {:serial, :rx1} -> <<0x0A, 0x02>>
        {:serial, :tx1} -> <<0x0A, 0x03>>
        {:serial, :rx2} -> <<0x0A, 0x04>>
        {:serial, :tx2} -> <<0x0A, 0x05>>
        {:serial, :rx3} -> <<0x0A, 0x06>>
        {:serial, :tx3} -> <<0x0A, 0x07>>
        {:serial, :rx4} -> <<0x0A, 0x08>>
        {:serial, :tx4} -> <<0x0A, 0x09>>
        {:serial, :rx5} -> <<0x0A, 0x0A>>
        {:serial, :tx5} -> <<0x0A, 0x0B>>
        {:serial, :rx6} -> <<0x0A, 0x0C>>
        {:serial, :tx6} -> <<0x0A, 0x0D>>
        {:serial, :rx7} -> <<0x0A, 0x0E>>
        {:serial, :tx7} -> <<0x0A, 0x0F>>
      end)
      |> Enum.join(<<0x7F>>)

    SystemExclusive.init(0x6B, payload)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
