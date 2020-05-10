defmodule MidiProto.FirmataTest do
  alias MidiProto.Firmata
  alias MidiProto.Message
  use ExUnit.Case, async: true

  describe "convert/1" do
    test "it can decode an analog mapping query" do
      assert {:ok, %Firmata.AnalogMappingQuery{}} =
               Message.SystemExclusive.init(0x69, <<>>)
               |> Firmata.convert()
    end

    test "it can decode an analog mapping response" do
      assert {:ok, %Firmata.AnalogMappingResponse{pin_mappings: [9, 8, 7, 6, :not_supported]}} =
               Message.SystemExclusive.init(0x68, <<0x09, 0x08, 0x07, 0x06, 0x7F>>)
               |> Firmata.convert()
    end

    test "it can decode a capability query" do
      assert {:ok, %Firmata.CapabilityQuery{}} =
               Message.SystemExclusive.init(0x6B, <<>>)
               |> Firmata.convert()
    end

    test "it can decode a capability response" do
      assert {:ok,
              %Firmata.CapabilityResponse{
                capabilities: [
                  :digital_input,
                  :digital_output,
                  {:analog_input, 8},
                  {:pwm, 14},
                  {:servo, 12},
                  :shift,
                  :unsupported,
                  :i2c,
                  :onewire,
                  {:stepper, 7},
                  :encoder,
                  {:serial, :rx0},
                  {:serial, :tx0},
                  :input_pullup
                ]
              }} =
               Message.SystemExclusive.init(
                 0x6B,
                 <<0x00, 0x01, 0x7F, 0x01, 0x01, 0x7F, 0x02, 0x08, 0x7F, 0x03, 0x0E, 0x7F, 0x04,
                   0xC, 0x7F, 0x05, 0x00, 0x7F, 0x7F, 0x06, 0x00, 0x7F, 0x07, 0x00, 0x7F, 0x08,
                   0x07, 0x7F, 0x09, 0x00, 0x7F, 0x0A, 0x00, 0x7F, 0x0A, 0x01, 0x7F, 0x0B, 0x00>>
               )
               |> Firmata.convert()
    end

    test "it can decode a pin state query" do
      assert {:ok, %Firmata.PinStateQuery{pin: 1}} =
               Message.SystemExclusive.init(0x6D, <<0x01>>)
               |> Firmata.convert()
    end

    test "it can decode a pin state response" do
      assert {:ok, %Firmata.PinStateResponse{pin: 1, mode: :analog, state: <<1, 2, 3>>}} =
               Message.SystemExclusive.init(0x6E, <<0x01, 0x02, 0x01, 0x02, 0x03>>)
               |> Firmata.convert()
    end

    test "it can decode an extended analog" do
      assert {:ok, %Firmata.ExtendedAnalog{pin: 1, bytes: <<0x7F>>}} =
               Message.SystemExclusive.init(0x6F, <<0x01, 0x7F>>)
               |> Firmata.convert()
    end

    test "it can decode a string data" do
      assert {:ok, %Firmata.StringData{string: "Marty McFly"}} =
               Message.SystemExclusive.init(
                 0x71,
                 <<0x4D, 0x00, 0x61, 0x00, 0x72, 0x00, 0x74, 0x00, 0x79, 0x00, 0x20, 0x00, 0x4D,
                   0x00, 0x63, 0x00, 0x46, 0x00, 0x6C, 0x00, 0x79, 0x00>>
               )
               |> Firmata.convert()
    end

    test "it can decode a sampling interval" do
      assert {:ok, %Firmata.SamplingInterval{interval: 1234}} =
               Message.SystemExclusive.init(0x7A, <<0x52, 0x09>>)
               |> Firmata.convert()
    end

    test "it can decode a firmware query" do
      assert {:ok, %Firmata.FirmwareQuery{}} =
               Message.SystemExclusive.init(0x79, <<>>)
               |> Firmata.convert()
    end

    test "it can decode a firmware response" do
      assert {:ok, %Firmata.FirmwareResponse{}} =
               Message.SystemExclusive.init(0x79, <<0x01, 0x02, "Flux Capacitor"::binary>>)
               |> Firmata.convert()
    end
  end
end
