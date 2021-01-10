defmodule Mbtiles.MixProject do
  use Mix.Project

  def project do
    [
      app: :mbtiles,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mbtiles.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sqlitex, "~> 1.7"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Library that simpilfies working with mbtiles files"
  end

  defp package() do
    [
      source_url: "https://github.com/dkuku/mbtiles",
      files: ~w(lib mix.exs README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/dkuku/mbtiles"}
    ]
  end
end
