defmodule MidiProto.Message.Continue do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI continue system realtime message.
  """

  @type t :: %Continue{}

  @doc """
  Create a new MIDI continue system realtime message.
  """
  @spec init :: t
  def init, do: %Continue{}
end

defimpl MidiProto.Message, for: MidiProto.Message.Continue do
  import MidiProto.MessagePredicateGenerator

  def encode(_), do: <<0xFF>>

  generate_predicates(continue: true, system: true, realtime: true)
end
