defmodule ShoppingCartProcessesTest do
  use ExUnit.Case
  doctest ShoppingCartProcesses

  test "greets the world" do
    assert ShoppingCartProcesses.hello() == :world
  end
end
