defmodule Mix.Tasks.MbtilesUnpack do
  @moduledoc """
  allows to dump all files from a database to filesystem
  """
  use Mix.Task

  require Logger
  @path "priv/static/static_tiles"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:mbtiles)

    zoom_levels = Mbtiles.get_all_zoom_levels()
    Enum.map(zoom_levels, &process_zoom/1)
  end

  defp process_zoom(zoom) do
    zoom
    |> Mbtiles.get_all_y_coords()
    |> Enum.map(fn column -> process_columns(zoom, column) end)
  end

  defp process_columns(zoom, column) do
    mkdir(zoom, column)
  end

  defp mkdir(zoom, column) do
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

  defp dump_tiles(zoom, tile_column) do
    column = Mbtiles.get_all_y_tiles(zoom, tile_column)
    Enum.map(column, fn row -> save_file(row) end)
  end

  defp save_file(row) do
    %{zoom_level: zoom, tile_column: tile_column, tile_row: tile_row, tile_data: content} = row

    y = Mbtiles.get_tms_y(tile_row, zoom)
    extension = Mbtiles.get_extension(content)

    path =
      Path.join([
        @path,
        Integer.to_string(zoom),
        Integer.to_string(tile_column),
        Integer.to_string(y) <> "." <> convert_extension(extension)
      ])

    File.write(path, content)
  end

  defp convert_extension(extension), do: Atom.to_string(extension)
end
