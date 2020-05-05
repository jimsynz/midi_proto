defmodule MidiProto.Message.PitchBendTest do
  alias MidiProto.Message
  alias MidiProto.Message.PitchBend
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message PitchBend.init(1, 2)

  describe "init/2" do
    test "it creates a new message" do
      assert %PitchBend{channel: 1, bend: 2} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xE1, 0x02, 0x00>> = message
    end
  end

  test_message_impl_predicates(@message, pitch_bend: true)
end
