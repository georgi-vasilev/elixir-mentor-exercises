defmodule CartTasks do
  def add_item(item_id) do
    # returns a task, a process id and everything
    task = Task.async(fn -> Inventory.check_inventory(item_id) end)
    update_cart_ui(:loading)
    discount = calculate_promo_discount(item_id)
    apply_discount(discount)
    Task.yield(task, 3000)
    results = Task.await(task)
    case results do
      {:ok, _msg} ->
        update_cart_ui(:success, item_id)

      _ ->
        update_cart_ui(:error, item_id)
    end
  end

  defp update_cart_ui(:loading), do: IO.puts("Showing loading indicator in cart...")
  defp update_cart_ui(:success, item_id), do: IO.puts("Item #{item_id} was added to the cart.")
  defp update_cart_ui(:error, item_id), do: IO.puts("Failed to add #{item_id} to the cart.")

  defp calculate_promo_discount(item_id) do
    :timer.sleep(2000)
    10
  end

  defp apply_discount(discount), do: IO.puts("Applying #{discount}% discount to the cart.")
end
