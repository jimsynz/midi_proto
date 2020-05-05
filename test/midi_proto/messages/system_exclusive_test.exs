defmodule MidiProto.Message.SystemExclusiveTest do
  alias MidiProto.Message
  alias MidiProto.Message.SystemExclusive
  import MessageImplPredicateTestHelper
  use ExUnit.Case, async: true

  @message SystemExclusive.init(1, Base.encode64("Marty McFly"))

  describe "init/2" do
    test "it creates a new message when the vendor is an integer" do
      assert %SystemExclusive{vendor_id: 1, payload: "TWFydHkgTWNGbHk="} = @message
    end

    test "it creates a new message when the vendor is `:non_commercial`" do
      assert %SystemExclusive{vendor_id: 0x7D, payload: "TWFydHkgTWNGbHk="} =
               SystemExclusive.init(:non_commercial, Base.encode64("Marty McFly"))
    end

    test "it creates a new message when the vendor is `:predefined_nonrealtime`" do
      assert %SystemExclusive{vendor_id: 0x7E, payload: "TWFydHkgTWNGbHk="} =
               SystemExclusive.init(:predefined_nonrealtime, Base.encode64("Marty McFly"))
    end

    test "it creates a new message when the vendor is `:predefined_realtime`" do
      assert %SystemExclusive{vendor_id: 0x7F, payload: "TWFydHkgTWNGbHk="} =
               SystemExclusive.init(:predefined_realtime, Base.encode64("Marty McFly"))
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly when the vendor is a seven bit integer" do
      message = @message |> Message.encode()

      assert <<0xF0, 1, 0x54, 0x57, 0x46, 0x79, 0x64, 0x48, 0x6B, 0x67, 0x54, 0x57, 0x4E, 0x47,
               0x62, 0x48, 0x6B, 0x3D, 0xF7>> = message
    end

    test "it encodes the message correctly when the vendor is a fourteen bit integer" do
      message =
        SystemExclusive.init(0xFFF, Base.encode64("Marty McFly"))
        |> Message.encode()

      assert <<0xF0, 0, 0x1F, 0x7F, 0x54, 0x57, 0x46, 0x79, 0x64, 0x48, 0x6B, 0x67, 0x54, 0x57,
               0x4E, 0x47, 0x62, 0x48, 0x6B, 0x3D, 0xF7>> = message
    end
  end

  describe "Message.realtime?/1" do
    test "it is true when the vendor is `:predefined_realtime`" do
      assert Message.realtime?(SystemExclusive.init(:predefined_realtime, <<>>))
    end

    test "it is false" do
      refute Message.realtime?(@message)
    end
  end

  test_message_impl_predicates(@message, system: true, system_exclusive: true)
end
