defmodule MidiProto.Firmata.FirmwareQuery do
  alias __MODULE__
  defstruct []

  @moduledoc """
  Represents a Firmata firmware query implemented using a MIDI SysEx message.
  """

  @type t :: %FirmwareQuery{}

  @doc """
  Initialise a `FirmwareQuery` struct.
  """
  @spec init :: t
  def init, do: %FirmwareQuery{}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.FirmwareQuery do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(_),
    do:
      0x79
      |> SystemExclusive.init(<<>>)
      |> Message.encode()

  generate_predicates(system_exclusive: true, system: true)
end
