defmodule MidiProto.Firmata.PinStateQuery do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct pin: nil

  @moduledoc """
  Represents a Firmata pin state query implemented using a MIDI SysEx message.
  """

  @type t :: %PinStateQuery{pin: MidiProto.seven_bit_int()}

  @doc """
  Initialise a new `PinStateQuery` struct.
  """
  @spec init(MidiProto.seven_bit_int()) :: t
  def init(pin_number) when is_seven_bit_int(pin_number), do: %PinStateQuery{pin: pin_number}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.PinStateQuery do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator

  def encode(%{pin: pin}) do
    SystemExclusive.init(0x6D, <<0::integer-size(1), pin::integer-size(7)>>)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
