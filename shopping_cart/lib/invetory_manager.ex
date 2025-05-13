defmodule InventoryManager do
  def get_product(inventory, name) do
    find_product(inventory, name)
  end

  defp find_product([], _name), do: nil
  # with [%{name: name} = product | tail] we pattern match the name we pass
  defp find_product([%Product{name: name} = product | _tail], name), do: product
  defp find_product([_product | rest_inventory], name), do: find_product(rest_inventory, name)

  # def update_inventory(inventory, name, amount) do
  # Enum.map(inventory, fn product ->
  #  if product.name == name do
  #    %{product | quantity: product.quantity - amount}
  #  else
  #    product
  #  end
  # end)
  # end

  def update_inventory(inventory, name, amount) do
    update_products(inventory, name, amount, [])
  end

  defp update_products([], _name, _amount, updated_inventory), do: Enum.reverse(updated_inventory)

  defp update_products([product | rest], name, amount, updated_inventory) do
    updated_product =
      if product.name == name do
        %{product | quantity: product.quantity - amount}
      else
        product
      end

    # more efficient is to add the updated_product to the beginning of our list
    # so that we dont have to iterate through the whole list
    update_products(rest, name, amount, [updated_product | updated_inventory])
  end

  def update_inventory(inventory, item = %{name: name, amount: amount}) do
    Enum.map(inventory, fn product ->
      if product.name == name do
        %{product | quantity: product.quantity + amount}
      else
        product
      end
    end)
  end

  #  def restock(inventory) do
  #    Enum.map(inventory, fn product ->
  #      if product.quantity < product.reorder_level do
  #        %{product | quantity: product.quantity + product.reorder_amount}
  #      else
  #        product
  #      end
  #    end)
  #  end

  def restock([]), do: []

  def restock([
        %{quantity: quantity, reorder_level: reorder_level, reorder_amount: reorder_amount} =
          product
        | tail
      ]) do
    updated_product =
      if quantity < reorder_level do
        %{product | quantity: quantity + reorder_amount}
      else
        product
      end

    [updated_product | restock(tail)]
  end

  def update_supplier_phone(inventory, product_name, new_phone) do
    Enum.map(inventory, fn product ->
      if product.name == product_name do
        %Product{product | supplier: %Supplier{product.supplier | phone: new_phone}}
      else
        product
      end
    end)
  end
end
