defmodule MidiProto.Firmata.FirmwareResponse do
  alias __MODULE__
  defstruct major_version: nil, minor_version: nil, name: nil
  import MidiProto.Helper.Guards

  @moduledoc """
  Represents a Firmata firmware response using a MIDI SysEx message.
  """

  @type t :: %FirmwareResponse{
          major_version: MidiProto.seven_bit_int(),
          minor_version: MidiProto.seven_bit_int(),
          name: binary
        }

  @doc """
  Initialise a FirmwareResponse struct.
  """
  @spec init(MidiProto.seven_bit_int(), MidiProto.seven_bit_int(), binary) :: t
  def init(major_version, minor_version, name)
      when is_seven_bit_int(major_version) and is_seven_bit_int(minor_version) and is_binary(name) do
    %FirmwareResponse{major_version: major_version, minor_version: minor_version, name: name}
  end
end

defimpl MidiProto.Message, for: MidiProto.Firmata.FirmwareResponse do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator
  alias MidiProto.Firmata.String

  def encode(%{major_version: major_version, minor_version: minor_version, name: name}) do
    {:ok, name} = String.encode(name)

    SystemExclusive.init(
      0x79,
      <<0::integer-size(1), major_version::integer-size(7), 0::integer-size(1),
        minor_version::integer-size(7), name::binary>>
    )
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
