defmodule Mix.Tasks.MbtilesUnpack do
  @moduledoc """
  allows to dump all files from a database to filesystem
  """
  use Mix.Task

  require Logger
  @path "priv/static/static_tiles"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:mbtiles)

    Mbtiles.DB.get_all_zoom_levels()
    |> Enum.map(fn [zoom_level: zoom] -> process_zoom(zoom) end)
  end

  def process_zoom(zoom) do
    Mbtiles.DB.process_zoom(zoom)
    |> Enum.map(fn [tile_column: column] -> process_columns(zoom, column) end)
  end

  def process_columns(zoom, column) do
    mkdir(zoom, column)
    Logger.error(column)
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

  def dump_tiles(zoom, column) do
    Mbtiles.DB.dump_tiles(zoom, column)
    |> Enum.map(fn row -> save_file(row) end)
  end

  def save_file(row) do
    [
      zoom_level: zoom,
      tile_column: column,
      tile_row: y_stored,
      tile_data: {:blob, content}
    ] = row

    y = Mbtiles.DB.get_tms_y(y_stored, zoom)

    path =
      Path.join([
        @path,
        Integer.to_string(zoom),
        Integer.to_string(column),
        Integer.to_string(y) <> "." <> get_extension(content)
      ])

    File.write(path, content)
  end

  defp get_extension(<<0x89, 0x50, 0x4E, 0x47, _rest::bytes>> = _png), do: "png"
  defp get_extension(<<0xFF, _rest::bytes>> = _jpeg), do: "jpeg"
  defp get_extension(_), do: "pbf.gz"
end
