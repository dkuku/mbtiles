defmodule Mbtiles do
  @moduledoc false

  require Logger

  @doc """
  returns the tile with specific coordinates
  """
  @spec get_tile(integer, integer, integer) :: {atom, binary} | {:error, any}
  def get_tile(zoom, x, y, opts \\ []) do
    y = maybe_get_tms_y(y, zoom, opts[:tms])

    with %{tile_data: tile} when not is_nil(tile) <- Queries.get_tile(zoom, x, y) do
      tile
    else
      error ->
        Logger.error(inspect(error), module: __MODULE__)
        {:error, error}
    end
  end

  @doc """
  returns the database metadata
  """
  @spec get_metadata() :: map | {:error, any}
  def get_metadata() do
    Queries.get_metadata()
  end

  @doc """
  returns the possible zoom levels
  """
  @spec get_all_zoom_levels() :: [integer]
  def get_all_zoom_levels() do
    Queries.get_all_zoom_levels()
  end

  @doc """
  returns the possible y coordinates
  """
  @spec get_all_y_coords(integer) :: [integer]
  def get_all_y_coords(zoom) do
    Queries.process_zoom(zoom)
  end

  @doc """
  returns all tiles for given zoom and y coordinate
  """
  @spec get_all_y_tiles(integer, integer) :: [binary]
  def get_all_y_tiles(zoom, column) do
    Queries.dump_tiles(zoom, column)
  end

  defp maybe_get_tms_y(y, z, true), do: get_tms_y(y, z)
  defp maybe_get_tms_y(y, _z, _), do: y

  def get_tms_y(y, z), do: round(:math.pow(2, z) - 1 - y)

  def get_extension(<<0x89, 0x50, 0x4E, 0x47, _rest::bytes>>), do: :png
  def get_extension(<<0xFF, _rest::bytes>>), do: :jpeg
  def get_extension(<<0x1F, 0x8B, 0x08, _rest::bytes>>), do: :pbf_gz
  def get_extension(<<26, _rest::bytes>>), do: :pbf
  def get_extension(_tile), do: :pbf
end
