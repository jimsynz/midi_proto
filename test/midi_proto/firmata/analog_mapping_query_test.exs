defmodule MidiProto.Firmata.AnalogMappingQueryTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.AnalogMappingQuery
  alias MidiProto.Message

  describe "init/0" do
    test "it generates a firmata analog mapping query message" do
      assert %AnalogMappingQuery{} = AnalogMappingQuery.init()
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x69, 0xF7>> = Message.encode(AnalogMappingQuery.init())
    end
  end
end
