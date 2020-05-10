defmodule MidiProto.Message.TimeCodeQuarterFrame do
  alias __MODULE__
  defstruct timecode: 0

  @moduledoc """
  A MIDI time code quarter frame system realtime message.
  """

  @type t :: %TimeCodeQuarterFrame{timecode: MidiProto.seven_bit_int()}

  @doc """
  Create a new MIDI time code quarter frame system realtime message.
  """
  @spec init(MidiProto.seven_bit_int()) :: t
  def init(timecode), do: %TimeCodeQuarterFrame{timecode: timecode}
end

defimpl MidiProto.Message, for: MidiProto.Message.TimeCodeQuarterFrame do
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{timecode: timecode}), do: <<0xF1, 0::integer-size(1), timecode::integer-size(7)>>

  generate_predicates(time_code_quarter_frame: true, system: true)
end
