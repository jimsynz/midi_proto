defmodule MidiProto.ParserTest do
  alias MidiProto.Parser

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

  use ExUnit.Case, async: true
  doctest Parser
  use Bitwise

  @marty Base.encode64("Marty")

  describe "parse/1" do
    test "can parse an incoming active sense message" do
      active_sense = ActiveSense.init()

      assert {:ok, [^active_sense], _parser} =
               Parser.init()
               |> Parser.append(<<0xFE>>)
               |> Parser.parse()
    end

    test "can parse an incoming channel pressure message" do
      channel_pressure = ChannelPressure.init(0, 64)

      assert {:ok, [^channel_pressure], _parser} =
               Parser.init()
               |> Parser.append(<<0xD0, 0x40>>)
               |> Parser.parse()
    end

    test "can parse a continue message" do
      continue = Continue.init()

      assert {:ok, [^continue], _parser} =
               Parser.init()
               |> Parser.append(<<0xFB>>)
               |> Parser.parse()
    end

    test "can parse a control change message" do
      control_change = ControlChange.init(0, 64, 127)

      assert {:ok, [^control_change], _parser} =
               Parser.init()
               |> Parser.append(<<0xB::integer-size(4), 0x0::integer-size(4), 0x40, 0x7F>>)
               |> Parser.parse()
    end

    test "can parse a note off message" do
      note_off = NoteOff.init(0, 64, 127)

      assert {:ok, [^note_off], _parser} =
               Parser.init()
               |> Parser.append(<<0x80, 0x40, 0x7F>>)
               |> Parser.parse()
    end

    test "can parse a note on message" do
      note_on = NoteOn.init(0, 64, 127)

      assert {:ok, [^note_on], _parser} =
               Parser.init()
               |> Parser.append(<<0x90, 0x40, 0x7F>>)
               |> Parser.parse()
    end

    test "can parse a pitch bend" do
      pitch_bend = PitchBend.init(0, 1234)

      msb = 1234 >>> 7
      lsb = 1234 &&& 0x7F

      assert {:ok, [^pitch_bend], _parser} =
               Parser.init()
               |> Parser.append(<<0xE::integer-size(4), 0::integer-size(4), lsb, msb>>)
               |> Parser.parse()
    end

    test "can parse a polyphonic pressure message" do
      polyphonic_pressure = PolyphonicPressure.init(0, 64, 127)

      assert {:ok, [^polyphonic_pressure], _parser} =
               Parser.init()
               |> Parser.append(<<0xA0, 0x40, 0x7F>>)
               |> Parser.parse()
    end

    test "can parse a program change message" do
      program_change = ProgramChange.init(0, 64)

      assert {:ok, [^program_change], _parser} =
               Parser.init()
               |> Parser.append(<<0xC0, 0x40>>)
               |> Parser.parse()
    end

    test "can parse a song position message" do
      song_position = SongPosition.init(1234)

      msb = 1234 >>> 7
      lsb = 1234 &&& 0x7F

      assert {:ok, [^song_position], _parser} =
               Parser.init()
               |> Parser.append(<<0xF2, lsb, msb>>)
               |> Parser.parse()
    end

    test "can parse a song select message" do
      song_select = SongSelect.init(127)

      assert {:ok, [^song_select], _parser} =
               Parser.init()
               |> Parser.append(<<0xF3, 0x7F>>)
               |> Parser.parse()
    end

    test "can parse a start message" do
      start = Start.init()

      assert {:ok, [^start], _parser} =
               Parser.init()
               |> Parser.append(<<0xFA>>)
               |> Parser.parse()
    end

    test "can parse a stop message" do
      stop = Stop.init()

      assert {:ok, [^stop], _parser} =
               Parser.init()
               |> Parser.append(<<0xFC>>)
               |> Parser.parse()
    end

    test "can parse a early-vendor system exclusive message" do
      sysex = SystemExclusive.init(64, @marty)

      assert {:ok, [^sysex], _parser} =
               Parser.init()
               |> Parser.append(<<0xF0, 0x40, @marty::binary, 0xF7>>)
               |> Parser.parse()
    end

    test "can parse a late-vendor system exclusive message" do
      sysex = SystemExclusive.init(0x7FF, @marty)

      assert {:ok, [^sysex], _parser} =
               Parser.init()
               |> Parser.append(<<0xF0, 0, 0x7F, 0x0F, @marty::binary, 0xF7>>)
               |> Parser.parse()
    end

    test "can parse a system exclusive message containing a system realtime message" do
      mcfly = Base.encode64("McFly")
      timing_clock = TimingClock.init()
      sysex = SystemExclusive.init(64, <<@marty::binary, mcfly::binary>>)

      assert {:ok, [^timing_clock, ^sysex], _parser} =
               Parser.init()
               |> Parser.append(<<0xF0, 0x40, @marty::binary, 0xF8, mcfly::binary, 0xF7>>)
               |> Parser.parse()
    end

    test "doesn't try and parse an incomplete sysex message" do
      assert {:ok, [], %Parser{buffer: <<0xF0, 0x7D, 0x01, 0x02, 0x03>>}} =
               Parser.init()
               |> Parser.append(<<0xF0, 0x7D, 0x01, 0x02, 0x03>>)
               |> Parser.parse()
    end

    test "can parse a system reset message" do
      system_reset = SystemReset.init()

      {:ok, [^system_reset], _parser} =
        Parser.init()
        |> Parser.append(<<0xFF>>)
        |> Parser.parse()
    end

    test "can parse a time code quarter frame" do
      time_code_quarter_frame = TimeCodeQuarterFrame.init(127)

      {:ok, [^time_code_quarter_frame], _parser} =
        Parser.init()
        |> Parser.append(<<0xF1, 0x7F>>)
        |> Parser.parse()
    end

    test "can parse a timing clock message" do
      timing_clock = TimingClock.init()

      {:ok, [^timing_clock], _parser} =
        Parser.init()
        |> Parser.append(<<0xF8>>)
        |> Parser.parse()
    end

    test "can parse a tune request message" do
      tune_request = TuneRequest.init()

      {:ok, [^tune_request], _parser} =
        Parser.init()
        |> Parser.append(<<0xF6>>)
        |> Parser.parse()
    end

    test "can parse firmata packet" do
      packet =
        <<240, 1, 0, 0, 0, 0, 0, 0, 0, 0, 50, 1, 97, 1, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12,
          1, 64, 1, 63, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 1, 60, 1, 63, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 23, 0, 106, 1, 63, 0, 72, 0, 97, 1, 122, 0, 20, 0, 46, 1, 71, 0, 9, 0, 64,
          0, 108, 1, 81, 0, 56, 1, 30, 0, 5, 1, 107, 1, 32, 0, 64, 0, 87, 1, 35, 1, 112, 0, 61, 0,
          10, 0, 87, 1, 11, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 1, 18, 0, 64, 1, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 48, 1, 64, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 1, 58, 0,
          64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 72, 1, 63, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 64, 1, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 72, 1, 63, 1, 82, 0, 56, 1, 30,
          0, 5, 1, 107, 1, 81, 0, 10, 0, 64, 0, 26, 1, 25, 1, 25, 1, 25, 1, 25, 1, 25, 0, 33, 0,
          64, 0, 87, 1, 35, 1, 112, 0, 61, 0, 10, 0, 87, 1, 11, 0, 64, 0, 36, 1, 112, 0, 61, 0,
          10, 0, 87, 1, 35, 1, 64, 1, 63, 1, 123, 0, 20, 0, 46, 1, 71, 0, 97, 1, 122, 0, 52, 1,
          63, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 100, 0, 19, 0, 247>>

      {:ok, [%SystemExclusive{}], _parser} =
        Parser.init()
        |> Parser.append(packet)
        |> Parser.parse()
    end
  end
end
