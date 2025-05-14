defmodule ProcessSpawner do
  def spawn_processes(number_of_processes) do
    1..number_of_processes
    |> Enum.each(fn order_id ->
      ProcessOrder.start_process(order_id)
    end)
  end
end
