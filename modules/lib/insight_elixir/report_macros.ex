defmodule InsightElixir.ReportMacros do
  defmacro log_report_generation(type) do
    quote do
      IO.puts("Generating #{unquote(type)} report")
    end
  end
end
