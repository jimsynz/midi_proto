defmodule MidiProto.Firmata.AnalogMappingResponse do
  alias __MODULE__
  defstruct pin_mappings: %{}
  import MidiProto.Helper.Guards

  @moduledoc """
  Represents a Firmata analog mapping response using a MIDI SysEx message.
  """

  @type pin_mapping :: non_neg_integer() | :not_supported
  @type t :: %AnalogMappingResponse{pin_mappings: [pin_mapping]}

  @doc """
  Initialise a AnalogMappingResponse struct.
  """
  @spec init([pin_mapping]) :: t
  def init(pin_mappings) when is_list(pin_mappings),
    do: %AnalogMappingResponse{pin_mappings: pin_mappings}
end

defimpl MidiProto.Message, for: MidiProto.Firmata.AnalogMappingResponse do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MidiProto.Helper.MessagePredicateGenerator
  import MidiProto.Helper.Guards

  def encode(%{pin_mappings: pin_mapping}) do
    payload =
      pin_mapping
      |> Enum.reduce(<<>>, fn
        :not_supported, buffer -> buffer <> <<127>>
        i, buffer when is_seven_bit_int(i) -> buffer <> <<0::integer-size(1), i::integer-size(7)>>
      end)

    SystemExclusive.init(0x69, payload)
    |> Message.encode()
  end

  generate_predicates(system_exclusive: true, system: true)
end
