defmodule MidiProto.Firmata.String do
  import Bitwise

  @moduledoc """
  Handles encoding and decoding strings (and binaries) using Firmata's two-byte
  encoding method.
  """

  @doc """
  Encode binary values into two-byte sequences:

  ## Example

      iex> "Marty McFly"
      ...> |> encode()
      {:ok, <<0x4d, 0x00, 0x61, 0x00, 0x72, 0x00, 0x74, 0x00, 0x79, 0x00, 0x20, 0x00, 0x4d, 0x00, 0x63, 0x00, 0x46, 0x00, 0x6c, 0x00, 0x79, 0x00>>}
  """
  @spec encode(value :: binary) :: {:ok, binary}
  def encode(value) when is_binary(value), do: do_encode("", value)

  @doc """
  Decode two-byte sequences back into a binary:

  ## Example

      iex> <<0x4d, 0x00, 0x61, 0x00, 0x72, 0x00, 0x74, 0x00, 0x79, 0x00, 0x20, 0x00, 0x4d, 0x00, 0x63, 0x00, 0x46, 0x00, 0x6c, 0x00, 0x79, 0x00>>
      ...> |> decode()
      {:ok, "Marty McFly"}
  """
  @spec decode(value :: binary) :: {:ok, binary} | {:error, reason :: any}
  def decode(value) when is_binary(value), do: do_decode("", value)

  defp do_encode(result, ""), do: {:ok, result}

  defp do_encode(result, <<byte::integer, rest::binary>>) do
    lsb = byte &&& 0x7F
    msb = byte >>> 7

    do_encode(
      result <>
        <<0::integer-size(1), lsb::integer-size(7), 0::integer-size(1), msb::integer-size(7)>>,
      rest
    )
  end

  defp do_decode(result, <<>>), do: {:ok, result}

  defp do_decode(
         result,
         <<0::integer-size(1), lsb::integer-size(7), 0::integer-size(1), msb::integer-size(7),
           rest::binary>>
       ) do
    byte = (msb <<< 7) + lsb &&& 0xFF
    do_decode(result <> <<byte::integer>>, rest)
  end

  defp do_decode(_, _), do: {:error, "Invalid string"}
end
