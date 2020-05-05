defmodule MidiProto.Message.SystemReset do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI system reset system realtime message.
  """

  @type t :: %SystemReset{}

  @doc """
  Create a new MIDI system reset system realtime message.
  """
  @spec init :: t
  def init, do: %SystemReset{}
end

defimpl MidiProto.Message, for: MidiProto.Message.SystemReset do
  import MidiProto.MessagePredicateGenerator

  def encode(_), do: <<0xFF>>

  generate_predicates(system_reset: true, system: true, realtime: true)
end
