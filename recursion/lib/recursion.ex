defmodule Recursion do
  @moduledoc """
  Documentation for `Recursion`.
  """

  # Base case
  def countdown(0), do: IO.puts("Finished")

  def countdown(n) when n > 0 do
    IO.puts(n)
    countdown(n - 1)
  end

  def total(0), do: 0
  def total(n), do: n + total(n - 1)

  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n) when n > 1 do
    fib(n-1) + fib(n-2)
  end
end
