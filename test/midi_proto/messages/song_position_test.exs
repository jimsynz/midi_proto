defmodule MidiProto.Message.SongPositionTest do
  alias MidiProto.Message
  alias MidiProto.Message.SongPosition
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message SongPosition.init(1)

  describe "init/2" do
    test "it creates a new message" do
      assert %SongPosition{location: 1} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xF2, 0x01, 0x00>> = message
    end
  end

  test_message_impl_predicates(@message, song_position: true, system: true)
end
