defmodule OurStore.CartServer do
  use GenServer

  # client
  def start_link(name) do
    IO.puts("Cart server starting...")
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  def start_child(name) when is_atom(name) do
    IO.puts("Cart Server: #{name} is starting...")
    DynamicSupervisor.start_child(:dynamic_cart_sup, {__MODULE__, name})
  end

  def cart_total(cart_id) when is_atom(cart_id), do: GenServer.call(cart_id, :total)

  def add_item(cart_id, item) when is_atom(cart_id) do
    GenServer.cast(cart_id, {:add_item, item})
  end

  # callbacks
  @impl true
  def init(_state) do
    {:ok, %{cart: [], timer_pid: nil}}
  end

  @impl true
  def handle_call(:total, _from, state) do
    total =
      state.cart
      |> Enum.reduce(0, fn item, acc -> acc + item[:price] * item[:quantity] end)

    {:reply, total, state}
  end

  @impl true
  def handle_cast({:add_item, item}, state) do
    new_state =
      %{state | cart: [item | state.cart]}
      |> reminder_timer()

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:reminder, state) do
    IO.puts("Don't forget about those items you need!")
    {:noreply, state}
  end

  def child_spec(name) do
    %{
      # by default the id is module name
      id: __MODULE__,
      restart: :permanent,
      shutdown: 5000,
      start: {__MODULE__, :start_link, [name]},
      # all processes are workers except for supervisors.
      type: :worker
    }
  end

  defp reminder_timer(state) do
    case state[:timer_pid] do
      nil ->
        %{state | timer_pid: Process.send_after(self(), :reminder, 10_000)}

      _ ->
        Process.cancel_timer(state[:timer_pid])
        %{state | timer_pid: Process.send_after(self(), :reminder, 10_000)}
    end
  end
end
