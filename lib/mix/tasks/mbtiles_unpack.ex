defmodule Mix.Tasks.MbtilesUnpack do
  use Mix.Task

  @path "priv/static/static_tiles"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:mbtiles)

    Mbtiles.DB.query("select distinct(zoom_level) from tiles;")
    |> Enum.map(fn [zoom_level: zoom] -> process_zoom(zoom) end)
  end

  def process_zoom(zoom) do
    Mbtiles.DB.query(
      "select distinct(tile_column) from tiles where zoom_level = #{zoom} ;"
    )
    |> Enum.map(fn [tile_column: column] -> process_columns(zoom, column) end)
  end

  def process_columns(zoom, column) do
    mkdir(zoom, column)
    IO.inspect(column)
  end

  def mkdir(zoom, column) do
    path = Path.join([@path, Integer.to_string(zoom), Integer.to_string(column)])

    case File.mkdir_p(path) do
      :ok ->
        dump_files(zoom, column)

      error ->
        IO.inspect(error)
        IO.inspect(path)
        dump_files(zoom, column)
    end
  end

  def dump_files(zoom, column) do
    Mbtiles.DB.query(
      "select * from tiles where zoom_level = #{zoom} and tile_column = #{column} ;"
    )
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
