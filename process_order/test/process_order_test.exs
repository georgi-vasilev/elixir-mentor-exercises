defmodule ProcessOrderTest do
  use ExUnit.Case
  doctest ProcessOrder

  test "greets the world" do
    assert ProcessOrder.hello() == :world
  end
end
