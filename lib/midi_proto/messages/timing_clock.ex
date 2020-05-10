defmodule MidiProto.Message.TimingClock do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI timing clock system realtime message.
  """

  @type t :: %TimingClock{}

  @doc """
  Create a new MIDI timing clock system realtime message.
  """
  @spec init :: t
  def init, do: %TimingClock{}
end

defimpl MidiProto.Message, for: MidiProto.Message.TimingClock do
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(_), do: <<0xF8>>

  generate_predicates(timing_clock: true, system: true, realtime: true)
end
