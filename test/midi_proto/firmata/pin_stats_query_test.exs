defmodule MidiProto.Firmata.PinStateQueryTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.PinStateQuery
  alias MidiProto.Message

  describe "init/0" do
    test "it generates a firmata pin state query message" do
      assert %PinStateQuery{pin: 1} = PinStateQuery.init(1)
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x6D, 0x01, 0xF7>> = Message.encode(PinStateQuery.init(1))
    end
  end
end
