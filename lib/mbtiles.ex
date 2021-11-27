defmodule Mbtiles.DB do
  @moduledoc false

  import AyeSQL, only: [defqueries: 3]
  defqueries(Queries, "queries.sql", repo: Mbtiles.Repo, runner: Mbtiles.MbtilesRunner)

  require Logger

  def get_images(z, x, y, opts \\ []) do
    y = maybe_get_tms_y(y, z, opts[:tms])
    database = opts[:database] || Mbtiles

    with {:ok, %Exqlite.Result{rows: data}} <- Queries.get_tile([zoom: z, x: x, y: y], database: database),
         [tile] <- data do
      process_file(tile, opts)
    else
      error ->
        Logger.error(inspect(error))
        {:error, error}
    end
  end

  def get_metadata(repo \\ repo: Mbtiles.Repo) do
    case Queries.get_metadata([], database: database) do
      {:ok, %Exqlite.Result{rows: rows}} ->
        Enum.reduce(rows, %{}, fn [name, value], acc ->
          Map.put(acc, String.to_atom(name), value)
        end)

      error ->
        Logger.error(inspect(error))
        {:error, error}
    end
  end

  def get_all_zoom_levels(database \\ repo: MBtiles.Repo) do
    {:ok, %Exqlite.Result{rows: rows}} = Queries.get_all_zoom_levels([], database)
    {:ok, rows}
  end

  def process_zoom(zoom, database \\ repo: MBtiles.Repo) do
    {:ok, %Exqlite.Result{rows: rows}} = Queries.process_zoom([zoom: zoom], database)
    {:ok, rows}
  end

  def dump_tiles(zoom, column, database \\ repo: MBtiles.Repo) do
    {:ok, %Exqlite.Result{rows: rows}} = Queries.dump_tiles([zoom: zoom, column: column], database)
    {:ok, rows}
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
