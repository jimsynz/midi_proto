defmodule MidiProto.Message.ChannelPressure do
  import MidiProto.Helper.Guards
  alias __MODULE__
  defstruct channel: 0, pressure: 0

  @moduledoc """
  A MIDI program change message.
  """

  @type t :: %ChannelPressure{
          channel: MidiProto.nybble(),
          pressure: MidiProto.seven_bit_int()
        }

  @doc """
  Create a new MIDI channel pressure message with the provided parameters.
  """
  @spec init(MidiProto.nybble(), MidiProto.seven_bit_int()) :: t
  def init(channel, pressure)
      when is_nybble(channel) and is_seven_bit_int(pressure),
      do: %ChannelPressure{channel: channel, pressure: pressure}
end

defimpl MidiProto.Message, for: MidiProto.Message.ChannelPressure do
  import MidiProto.MessagePredicateGenerator

  def encode(%{channel: channel, pressure: pressure}),
    do:
      <<0xD::integer-size(4), channel::integer-size(4), 0::integer-size(1),
        pressure::integer-size(7)>>

  generate_predicates(channel_pressure: true)
end
