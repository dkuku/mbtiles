defmodule MbtilesTest do
  use ExUnit.Case
  doctest Mbtiles

  test "all_zoom_levels" do
    assert Mbtiles.get_all_zoom_levels() == [0, 1, 2, 3, 4]
  end

  test "get_all_y_coords" do
    assert Mbtiles.get_all_y_coords(0) == [0, 1]
    assert Mbtiles.get_all_y_coords(1) == [0, 1, 2]
    assert Mbtiles.get_all_y_coords(2) == [0, 1, 2, 3, 4]
    assert Mbtiles.get_all_y_coords(-1) == []
    assert Mbtiles.get_all_y_coords(100) == []
  end

  test "get_all_y_tiles" do
    zoom = 0
    y = 0
    zoom_0 = Mbtiles.get_all_y_tiles(zoom, y)
    assert length(zoom_0) == 2
    assert [[^zoom, ^y, 0, _], [^zoom, ^y, 1, _]] = zoom_0
    zoom_1 = Mbtiles.get_all_y_tiles(1, y)
    assert length(zoom_1) == 3
    zoom_2 = Mbtiles.get_all_y_tiles(2, y)
    assert length(zoom_2) == 5
  end

  test "get_tile/4" do
    zoom = 0
    y = 0
    x = 1
    tile = Mbtiles.get_tile(zoom, x, y)
    assert <<137, 80, 78, 71, rest::bytes>> = tile
  end

  test "get_extension/4" do
    zoom = 0
    y = 0
    x = 1
    tile = Mbtiles.get_tile(zoom, x, y)
    assert Mbtiles.get_extension(tile) == :png
  end

  test "get_metadata" do
    metadata = Mbtiles.get_metadata()
    assert metadata == %{description: "", name: "control_room", type: "baselayer", version: "1.0.0"}
  end
end
