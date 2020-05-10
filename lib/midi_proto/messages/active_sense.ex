defmodule MidiProto.Message.ActiveSense do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI active sense system realtime message.
  """

  @type t :: %ActiveSense{}

  @doc """
  Create a new MIDI active sense system realtime message.
  """
  @spec init :: t
  def init, do: %ActiveSense{}
end

defimpl MidiProto.Message, for: MidiProto.Message.ActiveSense do
  import MidiProto.Helper.MessagePredicateGenerator
  def encode(_), do: <<0xFE>>

  generate_predicates(active_sense: true, system: true, realtime: true)
end
