defmodule MidiProto.Firmata.AnalogMappingResponseTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.AnalogMappingResponse
  alias MidiProto.Message

  @message AnalogMappingResponse.init([9, 8, 7, 6, :not_supported])

  describe "init/3" do
    test "it generates a firmata analog mapping response message" do
      assert %AnalogMappingResponse{pin_mappings: [9, 8, 7, 6, :not_supported]} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      assert <<0xF0, 0x69, 0x09, 0x08, 0x07, 0x06, 0x7F, 0xF7>> = Message.encode(@message)
    end
  end
end
