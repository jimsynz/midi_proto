# MidiProto

[![Build Status](https://drone.harton.dev/api/badges/james/midi_proto/status.svg)](https://drone.harton.dev/james/midi_proto)
[![Hex.pm](https://img.shields.io/hexpm/v/midi_proto.svg)](https://hex.pm/packages/midi_proto)
[![Hippocratic License HL3-FULL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-FULL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/full.html)

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

## Github Mirror

This repository is mirrored [on Github](https://github.com/jimsynz/angle)
from it's primary location [on my Forgejo instance](https://harton.dev/james/angle).
Feel free to raise issues and open PRs on Github.

## License

This software is licensed under the terms of the
[HL3-FULL](https://firstdonoharm.dev), see the `LICENSE.md` file included with
this package for the terms.

This license actively proscribes this software being used by and for some
industries, countries and activities. If your usage of this software doesn't
comply with the terms of this license, then [contact me](mailto:james@harton.nz)
with the details of your use-case to organise the purchase of a license - the
cost of which may include a donation to a suitable charity or NGO.
