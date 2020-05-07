defmodule MidiProto.Message.ContinueTest do
  alias MidiProto.Message
  alias MidiProto.Message.Continue
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message Continue.init()

  describe "init/2" do
    test "it creates a new message" do
      assert %Continue{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xFB>> = message
    end
  end

  test_message_impl_predicates(@message, system: true, realtime: true, continue: true)
end
