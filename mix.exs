defmodule MidiProto.MixProject do
  use Mix.Project

  @version "0.1.0"

  @description """
  Parsing and encoding of MIDI messages. Bring your own transport.
  """

  def project do
    [
      app: :midi_proto,
      version: @version,
      elixir: "~> 1.10",
      package: package(),
      description: @description,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def package do
    [
      maintainers: ["James Harton <james@automat.nz>"],
      licenses: ["Hippocratic"],
      links: %{
        "Source" => "https://gitlab.com/jimsy/midi_proto"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:earmark, ">= 0.0.0", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]}
    ]
  end
end
