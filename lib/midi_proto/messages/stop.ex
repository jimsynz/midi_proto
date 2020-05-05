defmodule MidiProto.Message.Stop do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI stop system realtime message.
  """

  @type t :: %Stop{}

  @doc """
  Create a new MIDI stop system realtime message.
  """
  @spec init :: t
  def init, do: %Stop{}
end

defimpl MidiProto.Message, for: MidiProto.Message.Stop do
  import MidiProto.MessagePredicateGenerator

  def encode(_), do: <<0xFC>>

  generate_predicates(stop: true, system: true, realtime: true)
end
