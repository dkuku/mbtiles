defmodule Mix.Tasks.MbtilesUnpackTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.MbtilesUnpack

  test "run" do
    File.rm_rf("priv/static")
    MbtilesUnpack.run([])
    {:ok, deleted} = File.rm_rf("priv/static")

    assert ["priv/static", "priv/static/static_tiles", "priv/static/static_tiles/1" | _rest] =
             deleted

    assert length(deleted) > 450
  end
end
