defmodule Product do
  # By default our only require us to pass in a name and price as the
  # rest have a default value
  defstruct [
    :name,
    :price,
    quantity: 0,
    reorder_level: 10,
    reorder_amount: 20,
    supplier: %Supplier{}
  ]

end
