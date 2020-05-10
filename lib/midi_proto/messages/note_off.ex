defmodule MidiProto.Message.NoteOff do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct channel: 0, note_number: 0, velocity: 0

  @moduledoc """
  A MIDI note-off message.
  """

  @type t :: %NoteOff{
          channel: MidiProto.nybble(),
          note_number: MidiProto.seven_bit_int(),
          velocity: MidiProto.seven_bit_int()
        }

  @doc """
  Create a new MIDI note-off message with the provided parameters.
  """
  @spec init(MidiProto.nybble(), MidiProto.seven_bit_int(), MidiProto.seven_bit_int()) :: t
  def init(channel, note_number, velocity)
      when is_nybble(channel) and is_seven_bit_int(note_number) and is_seven_bit_int(velocity),
      do: %NoteOff{channel: channel, note_number: note_number, velocity: velocity}
end

defimpl MidiProto.Message, for: MidiProto.Message.NoteOff do
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{channel: channel, note_number: note_number, velocity: velocity}),
    do:
      <<0x8::integer-size(4), channel::integer-size(4), 0::integer-size(1),
        note_number::integer-size(7), 0::integer-size(1), velocity::integer-size(7)>>

  generate_predicates(note_off: true)
end
