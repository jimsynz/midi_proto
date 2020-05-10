# MidiProto

This package allows for easy encoding and decoding of the
[MIDI](https://www.midi.org/) protocol.

It deals simply with encoding and decoding the byte protocol, and cares nothing
about transport - allowing you to easily put it into any use case.

Additionally, it supports a common subset of the
[Firmata](https://github.com/firmata/protocol) protocol that I needed.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `midi_proto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:midi_proto, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/midi_proto](https://hexdocs.pm/midi_proto).

