defmodule VisitorTracker do
  use Agent

  # Should only be used as real simple tasks. A perfect example is counter
  def start_link(_arg) do
    IO.puts("Visitor tracker starting...")
    Agent.start_link(fn -> %{} end, name: :visitor_tracker)
  end

  def add(item_id) do
    Agent.update(:visitor_tracker, fn counts ->
      # so how Map.update works
      # if it is a first time tracking an item it will add it with
      # default value the 3rd parameter
      # if the item is already there it will take the value 1 and add 1 to it
      Map.update(counts, item_id, 1, &(&1 + 1))
    end)
  end

  def remove(item_id) do
    Agent.update(:visitor_tracker, fn counts ->
      Map.update(counts, item_id, 0, &(&1 - 1))
    end)
  end

  def get_count(item_id) do
    Agent.get(:visitor_tracker, fn counts ->
      Map.get(counts, item_id, 0)
    end)
  end
end
