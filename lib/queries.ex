defmodule Queries do
  import Ecto.Query

  @doc """
  Selects a single tile from database.
  """
  def get_tile(zoom, x, y) do
    from("tiles",
      where: [zoom_level: ^zoom, tile_column: ^y, tile_row: ^x],
      select: [:tile_data]
    )
    |> Mbtiles.Repo.one()
  end

  @doc """
  Gets all of metadata.
  """
  def get_metadata() do
    from("metadata",
      select: [:name, :value]
    )
    |> Mbtiles.Repo.all()
    |> Enum.map(fn %{name: name, value: value} -> {String.to_atom(name), value} end)
    |> Enum.into(%{})
  end

  def get_all_zoom_levels do
    from("tiles",
      distinct: true,
      select: [:zoom_level]
    )
    |> Mbtiles.Repo.all()
    |> Enum.map(& &1.zoom_level)
  end

  def process_zoom(zoom) do
    from("tiles",
      select: [:tile_column],
      where: [zoom_level: ^zoom],
      distinct: true
    )
    |> Mbtiles.Repo.all()
    |> Enum.map(& &1.tile_column)
  end

  def dump_tiles(zoom, column) do
    from("tiles",
      distinct: true,
      select: [:zoom_level, :tile_column, :tile_row, :tile_data],
      where: [zoom_level: ^zoom, tile_column: ^column]
    )
    |> Mbtiles.Repo.all()
  end
end
