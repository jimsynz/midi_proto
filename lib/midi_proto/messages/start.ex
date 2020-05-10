defmodule MidiProto.Message.Start do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI start system realtime message.
  """

  @type t :: %Start{}

  @doc """
  Create a new MIDI start system realtime message.
  """
  @spec init :: t
  def init, do: %Start{}
end

defimpl MidiProto.Message, for: MidiProto.Message.Start do
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(_), do: <<0xFA>>

  generate_predicates(start: true, system: true, realtime: true)
end
