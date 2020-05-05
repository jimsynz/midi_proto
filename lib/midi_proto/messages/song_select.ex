defmodule MidiProto.Message.SongSelect do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct song: 0

  @moduledoc """
  A MIDI song select message.
  """

  @type t :: %SongSelect{
          song: MidiProto.seven_bit_int()
        }

  @doc """
  Create a new MIDI song select message with the provided parameters.
  """
  @spec init(MidiProto.seven_bit_int()) :: t
  def init(song)
      when is_seven_bit_int(song),
      do: %SongSelect{song: song}
end

defimpl MidiProto.Message, for: MidiProto.Message.SongSelect do
  import MidiProto.MessagePredicateGenerator
  use Bitwise

  def encode(%{song: song}) do
    <<0xF2, 0::integer-size(1), song::integer-size(7)>>
  end

  generate_predicates(song_select: true, system: true)
end
