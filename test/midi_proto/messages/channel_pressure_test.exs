defmodule MidiProto.Message.ChannelPressureTest do
  alias MidiProto.Message
  alias MidiProto.Message.ChannelPressure
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message ChannelPressure.init(1, 2)

  describe "init/2" do
    test "it creates a new message" do
      assert %ChannelPressure{channel: 1, pressure: 2} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xD1, 0x02>> = message
    end
  end

  test_message_impl_predicates(@message, channel_pressure: true)
end
