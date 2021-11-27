defmodule Mix.Tasks.MbtilesUnpack do
  @moduledoc """
  allows to dump all files from a database to filesystem
  """
  use Mix.Task

  require Logger
  @path "priv/static/static_tiles"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:mbtiles)

    {:ok, zoom_levels} = Mbtiles.DB.get_all_zoom_levels()
    Enum.map(zoom_levels, fn [zoom] -> process_zoom(zoom) end)
  end

  def process_zoom(zoom) do
    {:ok, zoom_levels} = Mbtiles.DB.process_zoom(zoom)
    
   Enum.map(zoom_levels, fn [column] -> process_columns(zoom, column) end)
  end

  def process_columns(zoom, column) do
    mkdir(zoom, column)
  end

  def mkdir(zoom, column) do
    path = Path.join([@path, Integer.to_string(zoom), Integer.to_string(column)])

    case File.mkdir_p(path) do
      :ok ->
        dump_tiles(zoom, column)

      error ->
        Logger.error(error)
        Logger.error(path)
        dump_tiles(zoom, column)
    end
  end

  def dump_tiles(zoom, tile_column) do
    {:ok, column} = Mbtiles.DB.dump_tiles(zoom, tile_column)
    Enum.map(column, fn row -> save_file(row) end)
  end

  def save_file(row) do
    [
      zoom,
      tile_column,
      tile_row,
      content
    ] = row

    y = Mbtiles.DB.get_tms_y(tile_row, zoom)
    {extension, _content} = Mbtiles.DB.get_extension(content, gzip: true)

    path =
      Path.join([
        @path,
        Integer.to_string(zoom),
        Integer.to_string(tile_column),
        Integer.to_string(y) <> "." <> convert_extension(extension)
      ])

    File.write(path, content)
  end

  defp convert_extension(:pbf_gz), do: "pbf.gz"
  defp convert_extension(extension), do: Atom.to_string(extension)
end
