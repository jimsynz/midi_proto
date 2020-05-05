defmodule MidiProto.Message.TuneRequestTest do
  alias MidiProto.Message
  alias MidiProto.Message.TuneRequest
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message TuneRequest.init()

  describe "init/2" do
    test "it creates a new message" do
      assert %TuneRequest{} = @message
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly" do
      message =
        @message
        |> Message.encode()

      assert <<0xF6>> = message
    end
  end

  test_message_impl_predicates(@message, system: true, tune_request: true)
end
