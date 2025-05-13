defmodule ShoppingCart do
  @moduledoc """
  Documentation for `ShoppingCart`.
  """

  def add_item(cart, product_name, amount, inventory) do
    # Does item exists?
    case InventoryManager.get_product(inventory, product_name) do
      nil ->
        {:error, :product_not_found}

      # Do we have enough to fulfill the order
      %Product{} = product when product.quantity >= amount ->
        # if true, we add item to the card and update the inventory
        new_cart = [%{name: product.name, amount: amount, price: product.price} | cart]
        new_inventory = InventoryManager.update_inventory(inventory, product.name, amount)
        {:ok, new_cart, new_inventory}

      _ ->
        {:error, :insufficient_stock}
    end
  end

  def remove_item(cart, item_to_remove, inventory) do
    {items_to_remove, updated_cart} =
      Enum.split_with(cart, fn cart_item -> cart_item.name == item_to_remove.name end)

    updated_inventory =
      case items_to_remove do
        [item | _] -> InventoryManager.update_inventory(inventory, item)
        [] -> inventory
      end

    {updated_cart, updated_inventory}
  end

  def remove_first([_head | tail]) do
    tail
  end

  def get_first(cart) do
    List.first(cart)
  end

  def get_last(cart) do
    List.last(cart)
  end

  def get_total(cart, discount \\ 0) do
    Enum.reduce(cart, 0, fn %{price: price, amount: amount}, acc ->
      acc + price * amount
    end)
    |> subtract_discount(discount)
  end

  defp subtract_discount(total, discount) do
    total * ((100 - discount) / 100)
  end
end
