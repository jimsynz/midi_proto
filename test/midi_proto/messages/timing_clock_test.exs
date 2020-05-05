defmodule MidiProto.Message.TimingClockTest do
  alias MidiProto.Message
  alias MidiProto.Message.TimingClock
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message TimingClock.init()

  describe "init/2" do
    test "it creates a new message" do
      assert %TimingClock{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xF8>> = message
    end
  end

  test_message_impl_predicates(@message, timing_clock: true, system: true, realtime: true)
end
