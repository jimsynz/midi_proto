defmodule MidiProto.Message.SystemExclusive do
  alias __MODULE__
  import MidiProto.Helper.Guards
  use Bitwise

  defstruct vendor_id: nil,
            payload: <<>>

  @moduledoc """
  A MIDI System Exclusive (SysEx) message.
  """
  @type vendor_id ::
          0..0x3FFF | :non_commercial | :predefined_nonrealtime | :predefined_realtime

  @type t :: %SystemExclusive{
          vendor_id: 0..0x3FFF,
          payload: binary
        }

  @doc """
  Initialise a new System Exclusive message.

  The payload parameter is a binary containing the payload to send.  Be aware
  that the payload must be encoded such that the MSB of each byte is always zero
  (as per the MIDI spec).  The easiest way to do this is to just base64 encode
  your data.
  """
  @spec init(vendor_id, binary) :: t
  def init(:non_commercial, payload) do
    %SystemExclusive{vendor_id: 0x7D, payload: payload}
  end

  def init(:predefined_nonrealtime, payload) do
    %SystemExclusive{vendor_id: 0x7E, payload: payload}
  end

  def init(:predefined_realtime, payload) do
    %SystemExclusive{vendor_id: 0x7F, payload: payload}
  end

  def init(vendor_id, payload) when is_fourteen_bit_int(vendor_id) do
    %SystemExclusive{
      vendor_id: vendor_id,
      payload: payload
    }
  end
end

defimpl MidiProto.Message, for: MidiProto.Message.SystemExclusive do
  import MidiProto.MessagePredicateGenerator
  import MidiProto.Helper.Guards
  use Bitwise

  def encode(%{vendor_id: vendor_id, payload: payload}) when is_seven_bit_int(vendor_id) do
    <<0xF0, 0::integer-size(1), vendor_id::integer-size(7), payload::binary, 0xF7>>
  end

  def encode(%{vendor_id: vendor_id, payload: payload}) when is_fourteen_bit_int(vendor_id) do
    lsb = vendor_id >>> 7
    msb = vendor_id &&& 0x7F

    <<0xF0, 0x00, 0::integer-size(1), lsb::integer-size(7), 0::integer-size(1),
      msb::integer-size(7), payload::binary, 0xF7>>
  end

  generate_predicates(system_exclusive: true, system: true)

  def realtime?(%{vendor_id: 0x7F}), do: true
  def realtime?(_), do: false
end
