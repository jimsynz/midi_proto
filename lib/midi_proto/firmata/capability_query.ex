defmodule MidiProto.Firmata.CapabilityQuery do
  alias __MODULE__
  defstruct []

  @moduledoc """
  Represents a Firmata capability query implemented using a MIDI SysEx message.
  """

  @type t :: %CapabilityQuery{}

  @doc """
  Initialise a new `CapabilityQuery` struct.
  """
  @spec init :: t
  def init, do: %CapabilityQuery{}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.CapabilityQuery do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(_) do
    SystemExclusive.init(0x6B, <<>>)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
