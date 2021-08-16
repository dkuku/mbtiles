-- name: get_tile
-- docs: Selects a single tile from database.
SELECT tile_data FROM tiles where zoom_level = :zoom and tile_column = :x and tile_row = :y

-- name: get_metadata
-- docs: Gets all of metadata.
SELECT * FROM metadata

-- name: get_all_zoom_levels
SELECT DISTINCT(zoom_level) FROM tiles

-- name: process_zoom
SELECT DISTINCT(tile_column) FROM tiles WHERE zoom_level = :zoom

-- name: dump_tiles
SELECT * FROM tiles WHERE zoom_level = :zoom AND tile_column = :column
