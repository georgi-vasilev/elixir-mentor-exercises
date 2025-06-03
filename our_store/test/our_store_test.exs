defmodule OurStoreTest do
  use ExUnit.Case
  doctest OurStore

  test "greets the world" do
    assert OurStore.hello() == :world
  end
end
