use Mix.Config

config :mbtiles,
  ecto_repos: [Mbtiles.Repo]

config :mbtiles, Mbtiles.Repo, database: "priv/test.mbtiles"

import_config "#{Mix.env()}.exs"
