defmodule MidiProto.Message.PitchBend do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct channel: 0, bend: 0

  @moduledoc """
  A MIDI pitch bend message.
  """

  @type t :: %PitchBend{
          channel: MidiProto.nybble(),
          bend: MidiProto.fourteen_bit_int()
        }

  @doc """
  Create a new MIDI pitch bend message with the provided parameters.
  """
  @spec init(MidiProto.nybble(), MidiProto.fourteen_bit_int()) :: t
  def init(channel, bend)
      when is_nybble(channel) and is_fourteen_bit_int(bend),
      do: %PitchBend{channel: channel, bend: bend}
end

defimpl MidiProto.Message, for: MidiProto.Message.PitchBend do
  import MidiProto.MessagePredicateGenerator
  use Bitwise

  def encode(%{channel: channel, bend: bend}) do
    msb = bend >>> 7
    lsb = bend &&& 0x7F

    <<0xE::integer-size(4), channel::integer-size(4), 0::integer-size(1), lsb::integer-size(7),
      0::integer-size(1), msb::integer-size(7)>>
  end

  generate_predicates(pitch_bend: true)
end
