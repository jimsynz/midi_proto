defmodule MidiProto.Message.PolyphonicPressure do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct channel: 0, note_number: 0, pressure: 0

  @moduledoc """
  A MIDI polyphonic pressure message.
  """

  @type t :: %PolyphonicPressure{
          channel: MidiProto.nybble(),
          note_number: MidiProto.seven_bit_int(),
          pressure: MidiProto.seven_bit_int()
        }

  @doc """
  Create a new MIDI polyphonic pressure message with the provided parameters.
  """
  @spec init(MidiProto.nybble(), MidiProto.seven_bit_int(), MidiProto.seven_bit_int()) :: t
  def init(channel, note_number, pressure)
      when is_nybble(channel) and is_seven_bit_int(note_number) and is_seven_bit_int(pressure),
      do: %PolyphonicPressure{channel: channel, note_number: note_number, pressure: pressure}
end

defimpl MidiProto.Message, for: MidiProto.Message.PolyphonicPressure do
  import MidiProto.MessagePredicateGenerator

  def encode(%{channel: channel, note_number: note_number, pressure: pressure}),
    do:
      <<0xA::integer-size(4), channel::integer-size(4), 0::integer-size(1),
        note_number::integer-size(7), 0::integer-size(1), pressure::integer-size(7)>>

  generate_predicates(polyphonic_pressure: true)
end
