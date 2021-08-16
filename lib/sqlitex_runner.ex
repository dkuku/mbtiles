defmodule SqlitexRunner do
  @moduledoc false
  use AyeSQL.Runner
  alias Sqlitex.Server

  alias AyeSQL.Query

  @impl true
  def run(%Query{statement: stmt, arguments: args}, opts) do
    database = Keyword.get(opts, :database) || raise ArgumentError, "No database spicified"
    Server.query(database, stmt, bind: args)
  end
end
