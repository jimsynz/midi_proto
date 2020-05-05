defmodule MidiProto.Message.StartTest do
  alias MidiProto.Message
  alias MidiProto.Message.Start
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message Start.init()

  describe "init/2" do
    test "it creates a new message" do
      assert %Start{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xFA>> = message
    end
  end

  test_message_impl_predicates(@message, system: true, start: true, realtime: true)
end
