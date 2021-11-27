defmodule Mbtiles.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [Mbtiles.Repo]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
