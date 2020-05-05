defmodule MidiProto.Message.ActiveSenseTest do
  alias MidiProto.Message
  alias MidiProto.Message.ActiveSense
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message ActiveSense.init()

  describe "init/2" do
    test "it creates a new message" do
      assert %ActiveSense{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xFE>> = message
    end
  end

  test_message_impl_predicates(@message, active_sense: true, system: true, realtime: true)
end
