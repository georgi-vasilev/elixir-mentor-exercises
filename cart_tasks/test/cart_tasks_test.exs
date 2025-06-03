defmodule CartTasksTest do
  use ExUnit.Case
  doctest CartTasks

  test "greets the world" do
    assert CartTasks.hello() == :world
  end
end
