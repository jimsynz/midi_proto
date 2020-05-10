defmodule MidiProto.Firmata.StringData do
  alias __MODULE__
  defstruct string: nil

  @moduledoc """
  Represents a Firmata string data message.
  """

  @type t :: %StringData{string: binary}

  @doc """
  Initialise a new `StringData` struct.
  """
  @spec init(binary) :: t
  def init(string), do: %StringData{string: string}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.StringData do
  alias MidiProto.Firmata.String
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{string: string}) do
    with {:ok, encoded} <- String.encode(string),
         sysex <- SystemExclusive.init(0x71, encoded),
         do: Message.encode(sysex)
  end

  generate_predicates(system_exclusive: true, system: true)
end
