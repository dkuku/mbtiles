use Mix.Config

config :mbtiles,
  ecto_repos: [Mbtiles.Repo]

config :mbtiles, Mbtiles.Repo,
  database: "priv/united_kingdom.mbtiles"

config :ayesql, run?: true
