defmodule MidiProto.Firmata.UserDefined do
  alias __MODULE__
  defstruct command_id: 1, payload: ""

  @moduledoc """
  Represents a Firmata user-defined command implemented using a MIDI SysEx message.
  """

  @type command_id :: 0x01..0x0F

  @type t :: %UserDefined{
          command_id: command_id,
          payload: binary
        }

  @doc """
  Initialise a new `UserDefined` struct.
  """
  @spec init(command_id, binary) :: t
  def init(command_id, bytes)
      when is_integer(command_id) and command_id >= 0x01 and command_id <= 0x0F and
             is_binary(bytes),
      do: %UserDefined{command_id: command_id, payload: bytes}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.UserDefined do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.MessagePredicateGenerator

  def encode(%{command_id: command_id, payload: bytes}) do
    command_id
    |> SystemExclusive.init(bytes)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
