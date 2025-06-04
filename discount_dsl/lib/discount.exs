defmodule Discount do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :discounts, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro discount(name, condition, action) do
    # bind_quoted instead of quote(name), quote(condition) etc.
    # its useful if we use the injected value more than once
    quote bind_quoted: [name: name, condition: condition, action: action] do
      @discounts {name, condition, action}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def apply_discounts(product) do
        Enum.reduce(@discounts, product, fn discount, product ->
          apply_discount_rule(product, discount)
        end)
      end

      defp apply_discount_rule(product, {_name, condition_func, action_func}) do
        # apply/3 Kernel function applying the function passed as second param to the list of args
        if apply(__MODULE__, condition_func, [product]) do
          apply(__MODULE__, action_func, [product])
        else
          product
        end
      end
    end
  end
end

defmodule Discounts do
  use Discount

  discount(:over_100, :is_over_100?, :apply_10_percent_discount)
  def is_over_100?(product), do: product.price > 100
  def apply_10_percent_discount(product), do: Map.update!(product, :price, &(&1 * 0.9))

  discount(:electronics, :is_electronics?, :apply_5_percent_discount)
  def is_electronics?(product), do: product.category == "Electronics"
  def apply_5_percent_discount(product), do: Map.update!(product, :price, &(&1 * 0.95))

  discount(:free_shipping, :is_eligible_for_free_shipping?, :apply_free_shipping)
  def is_eligible_for_free_shipping?(product), do: product.price > 50
  def apply_free_shipping(product), do: Map.put(product, :free_shipping, true)
end
