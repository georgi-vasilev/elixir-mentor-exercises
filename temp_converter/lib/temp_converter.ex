defmodule TempConverter do
  @moduledoc """
  Documentation for `TempConverter`.
  """

  def convert_temp(temp, from_unit, to_unit) when is_number(temp) do
    cond do
      {from_unit, to_unit} == {:celsius, :fahrenheit} -> celsius_to_fahrenheit(temp)
      {from_unit, to_unit} == {:fahrenheit, :celsius} -> fahreinheit_to_celsius(temp)
      true -> {:error, "Unsupported unit conversion"}
    end
  end

  defp celsius_to_fahrenheit(temp) do
    if temp < -273.15,
      do: {:error, "Below absolute zero"},
      else: temp * 9 / 5 + 32
  end

  defp fahreinheit_to_celsius(temp) do
    case temp do
      _ when temp < -459.67 -> {:error, "Below absolute zero"}
      _ -> (temp - 32) * 5 / 9
    end
  end
end
