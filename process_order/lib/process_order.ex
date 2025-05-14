defmodule ProcessOrder do
  @moduledoc """
  Documentation for `ProcessOrder`.
  """

  def start_process(order_id) do
    spawn(fn -> process_order(order_id) end)
  end

  defp process_order(order_id) do
    processing_time = :rand.uniform(5_000)
    Process.sleep(processing_time)
    IO.puts("Order #{order_id} processed in #{processing_time} ms")
  end
end
