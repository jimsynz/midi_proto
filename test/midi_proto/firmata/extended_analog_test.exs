defmodule MidiProto.Firmata.ExtendedAnalogTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.ExtendedAnalog
  alias MidiProto.Message

  describe "init/0" do
    test "it generates a firmata analog mapping query message" do
      assert %ExtendedAnalog{pin: 1, bytes: <<0x7F>>} = ExtendedAnalog.init(1, <<0x7F>>)
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x6F, 0x01, 0x7F, 0xF7>> = Message.encode(ExtendedAnalog.init(1, <<0x7F>>))
    end
  end
end
