defmodule Mbtiles.Helpers do
  def zoom_level_to_tile_size(zoom), do: 40_000_000 / :math.pow(2, zoom)

end
