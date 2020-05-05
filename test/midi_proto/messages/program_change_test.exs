defmodule MidiProto.Message.ProgramChangeTest do
  alias MidiProto.Message
  alias MidiProto.Message.ProgramChange
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message ProgramChange.init(1, 2)

  describe "init/2" do
    test "it creates a new message" do
      assert %ProgramChange{channel: 1, program_number: 2} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        1
        |> ProgramChange.init(2)
        |> Message.encode()

      assert <<0xC1, 0x02>> = message
    end
  end

  test_message_impl_predicates(@message, program_change: true)
end
