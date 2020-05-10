defmodule MidiProto.Helper.Guards do
  @moduledoc false

  defguard is_nybble(number) when is_integer(number) and number >= 0 and number <= 0xF
  defguard is_seven_bit_int(number) when is_integer(number) and number >= 0 and number <= 0x7F

  defguard is_fourteen_bit_int(number)
           when is_integer(number) and number >= 0 and number <= 0x3FFF
end
