defmodule ShoppingCartTest do
  use ExUnit.Case
  doctest ShoppingCart

  test "greets the world" do
    assert ShoppingCart.hello() == :world
  end
end
