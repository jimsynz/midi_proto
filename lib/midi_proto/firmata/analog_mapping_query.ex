defmodule MidiProto.Firmata.AnalogMappingQuery do
  alias __MODULE__
  defstruct []

  @moduledoc """
  Represents a Firmata analog mapping query implemented using a MIDI SysEx message.
  """

  @type t :: %AnalogMappingQuery{}

  @doc """
  Initialise a new `AnalogMappingQuery` struct.
  """
  @spec init :: t
  def init, do: %AnalogMappingQuery{}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.AnalogMappingQuery do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.MessagePredicateGenerator

  def encode(_) do
    SystemExclusive.init(0x69, <<>>)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
