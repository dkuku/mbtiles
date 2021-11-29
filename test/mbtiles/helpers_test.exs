defmodule Mbtiles.HelpersTest do
  use ExUnit.Case, async: true

  test "zoom level to tile size" do
    assert 4.0e7 == Mbtiles.Helpers.zoom_level_to_tile_size(0)
    assert 2.0e7 == Mbtiles.Helpers.zoom_level_to_tile_size(1)
    assert 1.0e7 == Mbtiles.Helpers.zoom_level_to_tile_size(2)
  end

  test "get_priv_path" do
    assert Mbtiles.Helpers.get_priv_path("123") =~ "_build/test/lib/mbtiles/priv/123"
  end
end
