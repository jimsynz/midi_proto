defmodule MidiProto.Message.TimeCodeQuarterFrameTest do
  alias MidiProto.Message
  alias MidiProto.Message.TimeCodeQuarterFrame
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message TimeCodeQuarterFrame.init(1)

  describe "init/2" do
    test "it creates a new message" do
      assert %TimeCodeQuarterFrame{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xF1, 0x01>> = message
    end
  end

  test_message_impl_predicates(@message, time_code_quarter_frame: true, system: true)
end
