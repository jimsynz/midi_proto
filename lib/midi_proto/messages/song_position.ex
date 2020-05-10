defmodule MidiProto.Message.SongPosition do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct location: 0

  @moduledoc """
  A MIDI song position message.
  """

  @type t :: %SongPosition{
          location: MidiProto.fourteen_bit_int()
        }

  @doc """
  Create a new MIDI song position message with the provided parameters.
  """
  @spec init(MidiProto.fourteen_bit_int()) :: t
  def init(location)
      when is_fourteen_bit_int(location),
      do: %SongPosition{location: location}
end

defimpl MidiProto.Message, for: MidiProto.Message.SongPosition do
  import MidiProto.Helper.MessagePredicateGenerator
  use Bitwise

  def encode(%{location: location}) do
    msb = location >>> 7
    lsb = location &&& 0x7F

    <<0xF2, 0::integer-size(1), lsb::integer-size(7), 0::integer-size(1), msb::integer-size(7)>>
  end

  generate_predicates(song_position: true, system: true)
end
