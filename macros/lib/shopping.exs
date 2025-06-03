defmodule Shopping do
  # + is the operation
  # we dont care about the AST structure
  # list of arguments
  defmacro cart({:+, _, [cart, item]}) do
    quote do
      cart = unquote(cart)
      item = unquote(item)

      new_cart = [item | cart]
      IO.puts("Added: #{item} to the cart, New cart: #{inspect(new_cart)}")
      new_cart
    end
  end

  defmacro cart({:-, _, [cart, item]}) do
    quote do
      cart = unquote(cart)
      item = unquote(item)

      new_cart = List.delete(cart, item)
      IO.puts("Removed: #{item} from the cart, New cart: #{inspect(new_cart)}")
      new_cart
    end
  end
end
