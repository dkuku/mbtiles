defmodule Mbtiles.MixProject do
  use Mix.Project

  def project do
    [
      app: :mbtiles,
      version: "0.1.0",
      elixir: "~> 1.07",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "mbtiles",
      links: 
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
      {:sqlitex, "~> 1.7"}
    ]
  end
end
