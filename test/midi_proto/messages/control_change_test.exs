defmodule MidiProto.Message.ControlChangeTest do
  alias MidiProto.Message
  alias MidiProto.Message.ControlChange
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message ControlChange.init(1, 2, 3)

  describe "init/2" do
    test "it creates a new message" do
      assert %ControlChange{channel: 1, controller_number: 2, value: 3} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        1
        |> ControlChange.init(2, 3)
        |> Message.encode()

      assert <<0xB1, 0x02, 0x03>> = message
    end
  end

  test_message_impl_predicates(@message, control_change: true)
end
