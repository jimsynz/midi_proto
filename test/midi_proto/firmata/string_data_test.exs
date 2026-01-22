defmodule MidiProto.Firmata.StringDataTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.StringData
  alias MidiProto.Message

  describe "init/3" do
    test "it generates a firmata string data message" do
      assert %StringData{string: "Marty McFly"} = StringData.init("Marty McFly")
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x71, 0x4D, 0x00, 0x61, 0x00, 0x72, 0x00, 0x74, 0x00, 0x79, 0x00, 0x20, 0x00,
               0x4D, 0x00, 0x63, 0x00, 0x46, 0x00, 0x6C, 0x00, 0x79, 0x00, 0xF7>> =
               Message.encode(StringData.init("Marty McFly"))
    end
  end
end
