defmodule MidiProto.Firmata.SamplingInterval do
  alias __MODULE__
  defstruct interval: nil
  import MidiProto.Helper.Guards

  @moduledoc """
  Represents the Firmata sampling interval message.
  """

  @type t :: %SamplingInterval{interval: MidiProto.fourteen_bit_int()}

  @doc """
  Initialise a new `SamplingInterval` struct.
  """
  @spec init(MidiProto.fourteen_bit_int()) :: t
  def init(interval) when is_fourteen_bit_int(interval), do: %SamplingInterval{interval: interval}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.SamplingInterval do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator
  import Bitwise

  def encode(%{interval: interval}) do
    lsb = interval &&& 0x7F
    msb = interval >>> 7

    0x7A
    |> SystemExclusive.init(<<lsb, msb>>)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
