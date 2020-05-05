defmodule MidiProto.Message.NoteOffTest do
  alias MidiProto.Message
  alias MidiProto.Message.NoteOff
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message NoteOff.init(1, 2, 3)

  describe "init/2" do
    test "it creates a new message" do
      assert %NoteOff{channel: 1, note_number: 2, velocity: 3} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0x81, 0x02, 0x03>> = message
    end
  end

  test_message_impl_predicates(@message, note_off: true)
end
