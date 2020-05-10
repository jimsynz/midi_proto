defmodule MidiProto.Parser do
  alias MidiProto.{Message, Parser}

  alias MidiProto.Message.{
    ActiveSense,
    ChannelPressure,
    Continue,
    ControlChange,
    NoteOff,
    NoteOn,
    PitchBend,
    PolyphonicPressure,
    ProgramChange,
    SongPosition,
    SongSelect,
    Start,
    Stop,
    SystemExclusive,
    SystemReset,
    TimeCodeQuarterFrame,
    TimingClock,
    TuneRequest
  }

  use Bitwise
  defstruct buffer: <<>>

  @moduledoc """
  Parses incoming MIDI data.

  Use this module to parse incoming MIDI data from your device and it'll convert
  it to a stream of message structs for you.  Handy, eh?

  ## Usage

  We split the receiving data and the parsing functions into separate functions
  so that you have the flexibility to handle incoming data without having pay
  the cost of parsing until you're ready.

  Here's an example of parsing a single MIDI note on message:

      iex> Parser.init()
      ...> |> Parser.append(<<145, 2, 3>>)
      ...> |> Parser.parse()
      {:ok, [%MidiProto.Message.NoteOn{channel: 1, note_number: 2, velocity: 3}], %Parser{}}

  You can call `append/2` and `parse/1` and number of times fill and empty the
  buffer as required.
  """

  @type t :: %Parser{buffer: binary}

  @doc """
  Initialize an empty parser struct ready to receive data.

      iex> Parser.init()
      %Parser{}

  """
  @spec init :: Parser.t()
  def init, do: %Parser{}

  @doc """
  Append some new incoming data to the end of the parser buffer.

  Usually you append a packet at a time, but partial packets are fine, as long
  as they are completed before the call to `parse/1` is made.

  ## Example

      iex> Parser.init()
      ...> |> Parser.append(<<0xff>>)
      %Parser{buffer: <<0xff>>}
  """
  @spec append(Parser.t(), binary) :: Parser.t()
  def append(%Parser{buffer: buffer}, new_bytes) when is_binary(new_bytes),
    do: %Parser{buffer: buffer <> new_bytes}

  @doc """
  Parse the contents of the buffer, returning zero or more messages.

  ## Example

      iex> Parser.init()
      ...> |> Parser.append(<<0xff>>)
      ...> |> Parser.parse()
      {:ok, [%SystemReset{}], %Parser{}}

  """
  @spec parse(Parser.t()) :: {:ok, [Message.t()], Parser.t()} | {:error, :invalid_packet}
  def parse(%Parser{} = parser), do: do_parse([], parser)

  @doc """
  Check if the parse buffer is empty.
  """
  @spec empty?(Parser.t()) :: boolean
  def empty?(%Parser{buffer: ""}), do: true

  defp do_parse(messages, parser) do
    case parse_packet(parser) do
      {:ok, [], parser} ->
        do_parse(messages, parser)

      {:ok, [message], parser} ->
        do_parse([message | messages], parser)

      {:ok, new_messages, parser} when is_list(new_messages) ->
        do_parse(Enum.concat(new_messages, messages), parser)

      :done ->
        {:ok, Enum.reverse(messages), parser}

      {:error, :no_sysex_stop_byte} ->
        {:ok, Enum.reverse(messages), parser}

      {:error, :invalid_packet} ->
        {:error, :invalid_packet}
    end
  end

  defp parse_packet(%Parser{buffer: ""}), do: :done

  defp parse_packet(
         %Parser{buffer: <<0::integer-size(1), _::integer-size(7), buffer::binary>>} = parser
       ),
       do: {:ok, [], %{parser | buffer: buffer}}

  defp parse_packet(%Parser{buffer: <<0xFE, buffer::binary>>} = parser),
    do: {:ok, [ActiveSense.init()], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0xD::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               pressure::integer-size(7), buffer::binary>>
         } = parser
       ),
       do: {:ok, [ChannelPressure.init(channel, pressure)], %{parser | buffer: buffer}}

  defp parse_packet(%Parser{buffer: <<0xFB, buffer::binary>>} = parser),
    do: {:ok, [Continue.init()], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0xB::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               controller::integer-size(7), 0::integer-size(1), value::integer-size(7),
               buffer::binary>>
         } = parser
       ),
       do: {:ok, [ControlChange.init(channel, controller, value)], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0x8::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               note_number::integer-size(7), 0::integer-size(1), velocity::integer-size(7),
               buffer::binary>>
         } = parser
       ),
       do: {:ok, [NoteOff.init(channel, note_number, velocity)], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0x9::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               note_number::integer-size(7), 0::integer-size(1), velocity::integer-size(7),
               buffer::binary>>
         } = parser
       ),
       do: {:ok, [NoteOn.init(channel, note_number, velocity)], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0xE::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               lsb::integer-size(7), 0::integer-size(1), msb::integer-size(7), buffer::binary>>
         } = parser
       ) do
    bend = (msb <<< 7) + lsb
    {:ok, [PitchBend.init(channel, bend)], %{parser | buffer: buffer}}
  end

  defp parse_packet(
         %Parser{
           buffer:
             <<0xA::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               note_number::integer-size(7), 0::integer-size(1), pressure::integer-size(7),
               buffer::binary>>
         } = parser
       ),
       do:
         {:ok, [PolyphonicPressure.init(channel, note_number, pressure)],
          %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0xC::integer-size(4), channel::integer-size(4), 0::integer-size(1),
               program_number::integer-size(7), buffer::binary>>
         } = parser
       ),
       do: {:ok, [ProgramChange.init(channel, program_number)], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0xF2, 0::integer-size(1), lsb::integer-size(7), 0::integer-size(1),
               msb::integer-size(7), buffer::binary>>
         } = parser
       ) do
    position = (msb <<< 7) + lsb
    {:ok, [SongPosition.init(position)], %{parser | buffer: buffer}}
  end

  defp parse_packet(
         %Parser{buffer: <<0xF3, 0::integer-size(1), song::integer-size(7), buffer::binary>>} =
           parser
       ),
       do: {:ok, [SongSelect.init(song)], %{parser | buffer: buffer}}

  defp parse_packet(%Parser{buffer: <<0xFA, buffer::binary>>} = parser),
    do: {:ok, [Start.init()], %{parser | buffer: buffer}}

  defp parse_packet(%Parser{buffer: <<0xFC, buffer::binary>>} = parser),
    do: {:ok, [Stop.init()], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{
           buffer:
             <<0xF0, 0::integer-size(9), lsb::integer-size(7), 0::integer-size(1),
               msb::integer-size(7), buffer::binary>>
         } = parser
       ) do
    vendor_id = (msb <<< 7) + lsb
    consume_sysex(vendor_id, %{parser | buffer: buffer})
  end

  defp parse_packet(
         %Parser{buffer: <<0xF0, 0::integer-size(1), vendor_id::integer-size(7), buffer::binary>>} =
           parser
       ) do
    consume_sysex(vendor_id, %{parser | buffer: buffer})
  end

  defp parse_packet(%Parser{buffer: <<0xFF, buffer::binary>>} = parser),
    do: {:ok, [SystemReset.init()], %{parser | buffer: buffer}}

  defp parse_packet(
         %Parser{buffer: <<0xF1, 0::integer-size(1), time_code::integer-size(7), buffer::binary>>} =
           parser
       ),
       do: {:ok, [TimeCodeQuarterFrame.init(time_code)], %{parser | buffer: buffer}}

  defp parse_packet(%Parser{buffer: <<0xF8, buffer::binary>>} = parser),
    do: {:ok, [TimingClock.init()], %{parser | buffer: buffer}}

  defp parse_packet(%Parser{buffer: <<0xF6, buffer::binary>>} = parser),
    do: {:ok, [TuneRequest.init()], %{parser | buffer: buffer}}

  defp parse_packet(_parser), do: {:error, :invalid_packet}

  defp consume_sysex(vendor_id, %Parser{buffer: buffer} = parser) do
    case consume_payload([], "", buffer) do
      {:ok, messages, payload, buffer} ->
        {:ok, [SystemExclusive.init(vendor_id, payload) | messages], %{parser | buffer: buffer}}

      {:error, :no_sysex_stop_byte} ->
        {:error, :no_sysex_stop_byte}
    end
  end

  # credo:disable-for-this-file Credo.Check.Refactor.Nesting
  defp consume_payload(messages, payload, buffer) do
    case consume_payload_bytes(buffer) do
      {:end, extra_payload, buffer} ->
        {:ok, messages, payload <> extra_payload, buffer}

      {:status, extra_payload, <<status_byte, buffer::binary>>} ->
        case parse_packet(%Parser{buffer: <<status_byte>>}) do
          {:ok, [message], _parser} ->
            if Message.system?(message) && Message.realtime?(message) do
              consume_payload([message | messages], payload <> extra_payload, buffer)
            else
              {:ok, messages, payload <> extra_payload, buffer}
            end

          {:error, _parser} ->
            {:ok, messages, payload <> extra_payload, buffer}
        end

      {:error, _payload} ->
        {:error, :no_sysex_stop_byte}
    end
  end

  defp consume_payload_bytes(buffer), do: consume_payload_bytes("", buffer)
  defp consume_payload_bytes(payload, <<0xF7, buffer::binary>>), do: {:end, payload, buffer}

  defp consume_payload_bytes(
         payload,
         <<0::integer-size(1), byte::integer-size(7), buffer::binary>>
       ),
       do:
         consume_payload_bytes(
           <<payload::binary, 0::integer-size(1), byte::integer-size(7)>>,
           buffer
         )

  defp consume_payload_bytes(payload, <<1::integer-size(1), _::bitstring>> = buffer),
    do: {:status, payload, buffer}

  defp consume_payload_bytes(payload, ""), do: {:error, payload}
end
