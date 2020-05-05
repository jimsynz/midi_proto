defmodule MidiProto.Message.TuneRequest do
  alias __MODULE__
  defstruct ~w[]

  @moduledoc """
  A MIDI tune request system message.
  """

  @type t :: %TuneRequest{}

  @doc """
  Create a new MIDI tune request system message.
  """
  @spec init :: t
  def init, do: %TuneRequest{}
end

defimpl MidiProto.Message, for: MidiProto.Message.TuneRequest do
  import MidiProto.MessagePredicateGenerator

  def encode(_), do: <<0xF6>>

  generate_predicates(tune_request: true, system: true)
end
