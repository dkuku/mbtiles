defmodule Mbtiles do
  @moduledoc false

  import AyeSQL, only: [defqueries: 3]
  defqueries(Queries, "queries.sql", repo: Mbtiles.Repo, runner: Mbtiles.MbtilesRunner)

  require Logger

  @doc """
  returns the tile with specific coordinates
  """
  @spec get_tile(integer, integer, integer, Keyword.t()) :: {atom, binary} | {:error, any}
  def get_tile(zoom, x, y, opts \\ []) do
    y = maybe_get_tms_y(y, zoom, opts[:tms])

    with {:ok, %Exqlite.Result{rows: data}} <- Queries.get_tile([zoom: zoom, x: x, y: y], opts),
         [[tile]] <- data do
      tile
    else
      error ->
        Logger.error(inspect(error))
        {:error, error}
    end
  end

  @doc """
  returns the database metadata
  """
  @spec get_metadata(Keyword.t()) :: map | {:error, any}
  def get_metadata(opts \\ []) do
    case Queries.get_metadata([], database: opts) do
      {:ok, %Exqlite.Result{rows: rows}} ->
        Enum.reduce(rows, %{}, fn [name, value], acc ->
          Map.put(acc, String.to_atom(name), value)
        end)

      error ->
        Logger.error(inspect(error))
        {:error, error}
    end
  end

  @doc """
  returns the possible zoom levels
  """
  @spec get_all_zoom_levels(Keyword.t()) :: [integer]
  def get_all_zoom_levels(opts \\ []) do
    {:ok, %Exqlite.Result{rows: rows}} = Queries.get_all_zoom_levels([], opts)
    Enum.map(rows, &hd/1)
  end

  @doc """
  returns the possible y coordinates
  """
  @spec get_all_y_coords(integer, Keyword.t()) :: [integer]
  def get_all_y_coords(zoom, opts \\ []) do
    {:ok, %Exqlite.Result{rows: rows}} = Queries.process_zoom([zoom: zoom], opts)
    Enum.map(rows, &hd/1)
  end

  @doc """
  returns all tiles for given zoom and y coordinate
  """
  @spec get_all_y_tiles(integer, integer, Keyword.t()) :: [binary]
  def get_all_y_tiles(zoom, column, opts \\ []) do
    {:ok, %Exqlite.Result{rows: columns}} = Queries.dump_tiles([zoom: zoom, column: column], opts)
    columns
  end

  defp maybe_get_tms_y(y, z, true), do: get_tms_y(y, z)
  defp maybe_get_tms_y(y, _z, _), do: y

  def get_tms_y(y, z), do: round(:math.pow(2, z) - 1 - y)

  def get_extension(<<0x89, 0x50, 0x4E, 0x47, _rest::bytes>>), do: :png
  def get_extension(<<0xFF, _rest::bytes>>), do: :jpeg
  def get_extension(_tile), do: :pbf
end
