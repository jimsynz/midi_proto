defmodule MidiProto.Firmata.UserDefinedTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.UserDefined
  alias MidiProto.Message

  describe "init/3" do
    test "it generates a firmata user defined message" do
      assert %UserDefined{command_id: 1, payload: "Marty McFly"} =
               UserDefined.init(1, "Marty McFly")
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x01, "Marty McFly"::binary, 0xF7>> =
               Message.encode(UserDefined.init(1, "Marty McFly"))
    end
  end
end
