defmodule MidiProto do
  @moduledoc """
  # MidiProto

  See `MidiProto.Parser` for information about parsing incoming MIDI messages
  into data structures.

  See `MidiProto.Message` for information about messages and encoding them into
  the wire.

  ## Examples

  Generating a note-on message for middle C and encoding it for transmission:

      iex> MidiProto.Message.NoteOn.init(0, 60, 127)
      ...> |> MidiProto.Message.encode()
      <<0x90, 0x3c, 0x7f>>

  Parsing an incoming packets:

      iex> MidiProto.Parser.init()
      ...> |> MidiProto.Parser.append(<<0x90, 0x3c, 0x7f>>)
      ...> |> MidiProto.Parser.parse()
      {:ok, [%MidiProto.Message.NoteOn{channel: 0, note_number: 60, velocity: 127}], %MidiProto.Parser{}}

  Generating a Firmata message:

      iex> MidiProto.Firmata.FirmwareQuery.init()
      ...> |> MidiProto.Message.encode()
      <<0xf0, 0x79, 0xf7>>

  Converting a MIDI message into a Firmata message:

      iex> MidiProto.Message.SystemExclusive.init(0x79, "")
      ...> |> MidiProto.Firmata.convert()
      {:ok, %MidiProto.Firmata.FirmwareQuery{}}
  """

  @type nybble :: 0..15
  @type seven_bit_int :: 0..127
  @type fourteen_bit_int :: 0..0x3FFF
end
