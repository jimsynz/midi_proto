defmodule MidiProto.Firmata.CapabilityResponseTest do
  use ExUnit.Case, async: true
  alias MidiProto.Firmata.CapabilityResponse
  alias MidiProto.Message

  describe "init/1" do
    test "it generates a firmata capability response message" do
      assert %CapabilityResponse{capabilities: [:unsupported]} =
               CapabilityResponse.init([:unsupported])
    end
  end

  describe "Message.encode/1" do
    test "it encodes the message correctly when there are a number of pins" do
      assert <<0xF0, 0x6B, 0x00, 0x01, 0x7F, 0x01, 0x01, 0xF7>> =
               Message.encode(CapabilityResponse.init([:digital_input, :digital_output]))
    end

    test "it encodes the message correctly when a pin is unsupported" do
      assert <<0xF0, 0x6B, 0x00, 0x01, 0x7F, 0xF7>> =
               Message.encode(CapabilityResponse.init([:digital_input, :unsupported]))
    end

    test "it encodes digital inputs correctly" do
      assert <<0xF0, 0x6B, 0x00, 0x01, 0xF7>> =
               Message.encode(CapabilityResponse.init(digital_input: 1))
    end

    test "it encodes digital outputs correctly" do
      assert <<0xF0, 0x6B, 0x01, 0x01, 0xF7>> =
               Message.encode(CapabilityResponse.init(digital_output: 1))
    end

    test "it encodes analog inputs correctly" do
      assert <<0xF0, 0x6B, 0x02, 0x13, 0xF7>> =
               Message.encode(CapabilityResponse.init(analog_input: 0x13))
    end

    test "it encodes pwm correctly" do
      assert <<0xF0, 0x6B, 0x03, 0x13, 0xF7>> = Message.encode(CapabilityResponse.init(pwm: 0x13))
    end

    test "it encodes servo correctly" do
      assert <<0xF0, 0x6B, 0x04, 0x13, 0xF7>> =
               Message.encode(CapabilityResponse.init(servo: 0x13))
    end

    test "it encodes shift correctly" do
      assert <<0xF0, 0x6B, 0x05, 0x00, 0xF7>> = Message.encode(CapabilityResponse.init([:shift]))
    end

    test "it encodes i2c correctly" do
      assert <<0xF0, 0x6B, 0x06, 0x00, 0xF7>> = Message.encode(CapabilityResponse.init([:i2c]))
    end

    test "it encodes one wire correctly" do
      assert <<0xF0, 0x6B, 0x07, 0x00, 0xF7>> =
               Message.encode(CapabilityResponse.init([:onewire]))
    end

    test "it encodes stepper correctly" do
      assert <<0xF0, 0x6B, 0x08, 0x13, 0xF7>> =
               Message.encode(CapabilityResponse.init(stepper: 0x13))
    end

    test "it encodes encoder correctly" do
      assert <<0xF0, 0x6B, 0x09, 0x00, 0xF7>> =
               Message.encode(CapabilityResponse.init([:encoder]))
    end

    for port <- 0..7 do
      @tag port: port
      test "it encodes serial rx#{port} correctly", %{port: port} do
        pin_byte = port * 2
        port_name = "rx#{port}" |> String.to_atom()

        assert <<0xF0, 0x6B, 0x0A, ^pin_byte, 0xF7>> =
                 Message.encode(CapabilityResponse.init(serial: port_name))
      end

      @tag port: port
      test "it encodes serial tx#{port} correctly", %{port: port} do
        pin_byte = port * 2 + 1
        port_name = "tx#{port}" |> String.to_atom()

        assert <<0xF0, 0x6B, 0x0A, ^pin_byte, 0xF7>> =
                 Message.encode(CapabilityResponse.init(serial: port_name))
      end
    end
  end
end
