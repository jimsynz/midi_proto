defmodule MidiProto.Message.ProgramChange do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct channel: 0, program_number: 0

  @moduledoc """
  A MIDI program change message.
  """

  @type t :: %ProgramChange{
          channel: MidiProto.nybble(),
          program_number: MidiProto.seven_bit_int()
        }

  @doc """
  Create a new MIDI program change message with the provided parameters.
  """
  @spec init(MidiProto.nybble(), MidiProto.seven_bit_int()) :: t
  def init(channel, program_number)
      when is_nybble(channel) and is_seven_bit_int(program_number),
      do: %ProgramChange{channel: channel, program_number: program_number}
end

defimpl MidiProto.Message, for: MidiProto.Message.ProgramChange do
  import MidiProto.MessagePredicateGenerator

  def encode(%{channel: channel, program_number: program_number}),
    do:
      <<0xC::integer-size(4), channel::integer-size(4), 0::integer-size(1),
        program_number::integer-size(7)>>

  generate_predicates(program_change: true)
end
