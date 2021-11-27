defmodule Mbtiles.MbtilesRunner do
  use AyeSQL.Runner

  alias AyeSQL.Query

  @impl true
  def run(%Query{statement: stmt, arguments: args}, options) do
    repo = options[:repo] || raise ArgumentError, "No repo defined"

    Ecto.Adapters.SQL.query(repo, stmt, args)
  end
end
