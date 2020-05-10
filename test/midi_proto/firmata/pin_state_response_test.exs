defmodule MidiProto.Firmata.PinStateResponseTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.PinStateResponse
  alias MidiProto.Message

  describe "init/3" do
    test "it generates a firmata pin state response message" do
      assert %PinStateResponse{pin: 1, mode: :input, state: <<1>>} =
               PinStateResponse.init(1, :input, <<1>>)
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x6E, 0x01, 0x02, 0x01, 0x02, 0x03, 0xF7>> =
               Message.encode(PinStateResponse.init(1, :analog, <<1, 2, 3>>))
    end
  end
end
