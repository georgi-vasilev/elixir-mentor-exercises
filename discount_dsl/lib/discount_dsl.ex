defmodule DiscountDsl do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :discounts, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def apply_discounts(product) do
        Enum.reduce(@discounts, product, fn discount, product ->
          apply_discount_rule(product, discount)
        end)
      end

      defp apply_discount_rule(product, {_name, required_fields, condition_func, action_func}) do
        # apply/3 Kernel function applying the function passed as second param to the list of args
        case validate_and_apply(product, required_fields, condition_func) do
          :apply -> apply(__MODULE__, action_func, [product])
          :skip -> product
        end
      end

      defp apply_discount_rule(product, _), do: product

      defp validate_product(product, required_fields) do
        Enum.all?(required_fields, &Map.has_key?(product, &1))
      end

      defp validate_and_apply(product, required_fields, condition_func) do
        if validate_product(product, required_fields) and
             apply(__MODULE__, condition_func, [product]) do
          :apply
        else
          :skip
        end
      end
    end
  end

  defmacro discount(name, required_fields, condition, action) do
    # bind_quoted instead of quote(name), quote(condition) etc.
    # its useful if we use the injected value more than once
    quote bind_quoted: [
            name: name,
            required_fields: required_fields,
            condition: condition,
            action: action
          ] do
      @discounts {name, required_fields, condition, action}
    end
  end
end
