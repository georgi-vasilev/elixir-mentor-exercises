defmodule CartSupervisor do
  use Supervisor

  def start_link(_arg) do
    IO.puts("Cart Supervisor starting...")
    # __MODULE__ current module
    Supervisor.start_link(__MODULE__, :ok, name: :cart_supervisor)
  end

  def init(_init_arg) do
    children = [
      {DynamicSupervisor, name: :dynamic_cart_sup}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
