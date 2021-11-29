# Mbtiles

you need a mbtils file for this package to work
to specify the location add an entry in your config.exs file

```
config :mbtiles,
  ecto_repos: [Mbtiles.Repo]

config :mbtiles, Mbtiles.Repo,
  database: "priv/united_kingdom.mbtiles"
```

## Example repository
[dkuku/tile_server](https://github.com/dkuku/tile_server)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mbtiles` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mbtiles, "~> 0.4.2"}
  ]
end
```
