defmodule MidiProto.Firmata.FirmwareResponseTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.FirmwareResponse
  alias MidiProto.Message

  @message FirmwareResponse.init(1, 2, "Flux Capacitor")

  describe "init/3" do
    test "it generates a firmata firmware response message" do
      assert %FirmwareResponse{major_version: 1, minor_version: 2, name: "Flux Capacitor"} =
               @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<240, 121, 1, 2, 70, 0, 108, 0, 117, 0, 120, 0, 32, 0, 67, 0, 97, 0, 112, 0, 97, 0,
               99, 0, 105, 0, 116, 0, 111, 0, 114, 0, 247>> = Message.encode(@message)
    end
  end
end
