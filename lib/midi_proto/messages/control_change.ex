defmodule MidiProto.Message.ControlChange do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct channel: 0, controller_number: 0, value: 0

  @moduledoc """
  A MIDI control change message.
  """

  @type t :: %ControlChange{
          channel: MidiProto.nybble(),
          controller_number: MidiProto.seven_bit_int(),
          value: MidiProto.seven_bit_int()
        }

  @doc """
  Create a new MIDI control change message with the provided parameters.
  """
  @spec init(MidiProto.nybble(), MidiProto.seven_bit_int(), MidiProto.seven_bit_int()) :: t
  def init(channel, controller_number, value)
      when is_nybble(channel) and is_seven_bit_int(controller_number) and is_seven_bit_int(value),
      do: %ControlChange{
        channel: channel,
        controller_number: controller_number,
        value: value
      }
end

defimpl MidiProto.Message, for: MidiProto.Message.ControlChange do
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{channel: channel, controller_number: controller_number, value: value}),
    do:
      <<0xB::integer-size(4), channel::integer-size(4), 0::integer-size(1),
        controller_number::integer-size(7), 0::integer-size(1), value::integer-size(7)>>

  generate_predicates(control_change: true)
end
