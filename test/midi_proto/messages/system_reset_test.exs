defmodule MidiProto.Message.SystemResetTest do
  alias MidiProto.Message
  alias MidiProto.Message.SystemReset
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message SystemReset.init()

  describe "init/2" do
    test "it creates a new message" do
      assert %SystemReset{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xFF>> = message
    end
  end

  test_message_impl_predicates(@message, system_reset: true, system: true, realtime: true)
end
