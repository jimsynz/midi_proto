defmodule MidiProto.Firmata.ExtendedAnalog do
  alias __MODULE__
  defstruct pin: nil, bytes: nil
  import MidiProto.Helper.Guards

  @moduledoc """
  Represents a Firmata extended analog message using a MIDI SysEx message.
  """

  @type t :: %ExtendedAnalog{
          pin: MidiProto.seven_bit_int(),
          bytes: binary
        }

  @doc """
  Initialise an `ExtendedAnalog` struct.
  """
  @spec init(MidiProto.seven_bit_int(), binary) :: t
  def init(pin, bytes) when is_seven_bit_int(pin) and is_binary(bytes),
    do: %ExtendedAnalog{pin: pin, bytes: bytes}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.ExtendedAnalog do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{pin: pin, bytes: bytes}),
    do:
      0x6F
      |> SystemExclusive.init(<<0::integer-size(1), pin::integer-size(7), bytes::binary>>)
      |> Message.encode()

  generate_predicates(system_exclusive: true, system: true)
end
