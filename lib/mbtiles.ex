defmodule Mbtiles.DB do
  alias Sqlitex.Server

  def get_images(z, x, y, opts \\ []) do
    y = maybe_get_tms_y(y, z, opts[:tms])
    database = opts[:database] || Mbtiles

    query =
      "SELECT tile_data FROM tiles where zoom_level = ? and tile_column = ? and tile_row = ?"

    with {:ok, [data]} <- Server.query(database, query, bind: [z, x, y]),
         [tile_data: tile_blob] <- data,
         {:blob, tile} <- tile_blob do
      process_file(tile, opts)
    else
      error ->
        IO.inspect(error)
        :error
    end
  end

  def get_metadata(database \\ Mbtiles) do
    query = "SELECT * FROM metadata"

    with {:ok, rows} <- Server.query(database, query) do
      Enum.reduce(rows, %{}, fn [name: name, value: value], acc ->
        Map.put(acc, String.to_atom(name), value)
      end)
    else
      error -> IO.inspect(error)
    end
  end

  def query(query) do
    {:ok, rows} = Server.query(Mbtiles, query)
    rows
  end

  defp maybe_get_tms_y(y, z, true), do: get_tms_y(y, z)
  defp maybe_get_tms_y(y, _z, _), do: y

  def get_tms_y(y, z), do: round(:math.pow(2, z) - 1 - y)

  def process_file(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _rest::bytes>> = png, _opts) do
    {:png, png}
  end

  def process_file(<<0xFF, _rest::bytes>> = jpeg, _opts) do
    {:jpeg, jpeg}
  end

  def process_file(tile, opts) do
    case opts[:gzip] do
      true -> {:pbf_gz, tile}
      _ -> {:pbf, :zlib.gunzip(tile)}
    end
  end
end
