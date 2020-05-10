defmodule MidiProto.Firmata.FirmwareQueryTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.FirmwareQuery
  alias MidiProto.Message

  describe "init/0" do
    test "it generates a firmata firmware query message" do
      assert %FirmwareQuery{} = FirmwareQuery.init()
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x79, 0xF7>> = Message.encode(FirmwareQuery.init())
    end
  end
end
