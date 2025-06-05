defmodule DiscountDslTest do
  use ExUnit.Case
  doctest DiscountDsl

  defmodule DiscountsTest do
    use DiscountDsl

    discount(:over_100, [:price], :is_over_100?, :apply_10_percent_discount)
    def is_over_100?(product), do: product.price > 100
    def apply_10_percent_discount(product), do: Map.update!(product, :price, &(&1 * 0.9))

    discount(:electronics, [:price, :category], :is_electronics?, :apply_5_percent_discount)
    def is_electronics?(product), do: product.category == "Electronics"
    def apply_5_percent_discount(product), do: Map.update!(product, :price, &(&1 * 0.95))

    discount(:free_shipping, [:price], :is_eligible_for_free_shipping?, :apply_free_shipping)
    def is_eligible_for_free_shipping?(product), do: product.price > 50
    def apply_free_shipping(product), do: Map.put(product, :free_shipping, true)
  end

  test "Ensure the Module loads" do
    assert Code.ensure_loaded?(DiscountDsl)
  end

  test "Single discount is applied correctly" do
    product = %{category: "Toys", price: 60}
    discounted_product = DiscountsTest.apply_discounts(product)

    assert discounted_product.free_shipping == true
    assert discounted_product.price == 60
    assert discounted_product.category == "Toys"
  end

  test "Multiple discounts are applied" do
    product = %{category: "Electronics", price: 100}
    discounted_product = DiscountsTest.apply_discounts(product)

    product2 = %{category: "Electronics", price: 200}
    discounted_product_2 = DiscountsTest.apply_discounts(product2)

    assert discounted_product.free_shipping == true
    assert discounted_product.price == 95
    assert discounted_product.category == "Electronics"

    assert discounted_product_2.free_shipping == true
    assert discounted_product_2.price == 171
    assert discounted_product_2.category == "Electronics"
  end

  test "No discounts are applied when conditions are not met" do
    product = %{category: "Toys", price: 40}
    discounted_product = DiscountsTest.apply_discounts(product)

    assert Map.has_key?(discounted_product, :free_shipping) == false
    assert discounted_product.price == 40
    assert discounted_product.category == "Toys"
  end

  test "Check edge case to make sure no discount is applied if product is $100" do
    product = %{category: "Accessories", price: 100}
    discounted_product = DiscountsTest.apply_discounts(product)

    assert discounted_product.price == 100
    assert discounted_product.free_shipping == true
    assert discounted_product.category == "Accessories"
  end

  test "Invalid product: missing price" do
    product = %{category: "Toys"}
    discounted_product = DiscountsTest.apply_discounts(product)

    assert discounted_product == product
  end
end
