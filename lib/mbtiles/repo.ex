defmodule Mbtiles.Repo do
  use Ecto.Repo, otp_app: :mbtiles, adapter: Ecto.Adapters.SQLite3
end
