defmodule MidiProto.Firmata.SamplingIntervalTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.SamplingInterval
  alias MidiProto.Message

  describe "init/3" do
    test "it generates a firmata sampling interval" do
      assert %SamplingInterval{interval: 1234} = SamplingInterval.init(1234)
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x7A, 0x52, 0x09, 0xF7>> = Message.encode(SamplingInterval.init(1234))
    end
  end
end
