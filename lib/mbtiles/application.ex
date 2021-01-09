defmodule Mbtiles.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Sqlitex.Server

  @impl true
  def start(_type, _args) do
    database_path = Application.get_env(:mbtiles, :mbtiles_path)

    children = [
      %{
        id: Server,
        start: {Server, :start_link, [database_path, [name: Mbtiles]]}
      }
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
