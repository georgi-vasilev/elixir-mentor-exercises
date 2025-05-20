defmodule ShoppingCartProcesses do
  @moduledoc """
  Documentation for `ShoppingCartProcesses`.
  """
  def start_cart do
    spawn(fn -> listen([]) end)
  end

  # should be recursive as we are waitign for a message
  # when a messages comes in then we process the message
  # and then we call this function again so after we process
  # the message coming in we wait for the next coming in
  defp listen(cart) do
    # pattern matches
    receive do
      {:add_item, item_name} ->
        new_cart = [item_name | cart]
        IO.puts("item added to cart: #{item_name}")
        # after add_item is received this process shuts down
        # so we call again listen() and thats how it recursively loops through
        listen(new_cart)

      {:remove_item, item_name} ->
        if item_name in cart do
          new_cart = List.delete(cart, item_name)
          IO.puts("Item #{item_name} removed")
          listen(new_cart)
        else
          IO.puts("Item #{item_name} not in cart.")
          listen(cart)
        end

      :show ->
        IO.puts("cart: #{inspect(cart)}")
        listen(cart)
    end
  end
end
