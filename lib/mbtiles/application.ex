defmodule Mbtiles.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Sqlitex.Server

  @impl true
  def start(_type, _args) do
    children = database_path() |> IO.inspect() |> Enum.map(&child/1)

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end

  defp database_path() do
    path = Application.get_env(:mbtiles, :mbtiles_path)
    IO.inspect(path)

    cond do
      is_bitstring(path) ->
        [{Mbtiles, path}]

      is_list(path) ->
        path

      is_nil(path) ->
        [{Mbtiles, "test/test.mbtiles"}]

      path ->
        IO.inspect("error #{path}")
        [{Mbtiles, "test/test.mbtiles"}]
    end
  end

  defp child({name, path}) do
    %{
      id: name,
      start: {Server, :start_link, [path, [name: name]]}
    }
  end
end
