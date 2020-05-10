defmodule MidiProto.Firmata.CapabilityQueryTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.CapabilityQuery
  alias MidiProto.Message

  describe "init/0" do
    test "it generates a firmata capability query message" do
      assert %CapabilityQuery{} = CapabilityQuery.init()
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x6B, 0xF7>> = Message.encode(CapabilityQuery.init())
    end
  end
end
