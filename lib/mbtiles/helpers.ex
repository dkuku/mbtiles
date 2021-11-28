defmodule Mbtiles.Helpers do
  @moduledoc false
  def zoom_level_to_tile_size(zoom), do: 40_000_000 / :math.pow(2, zoom)

  def get_priv_path(filename) do
    [:code.priv_dir(:mbtiles), filename]
    |> Path.join()
  end
end
