defmodule InsightElixir.ReportSetup do
 defmacro __using__(_)  do
    quote do
      def header, do: "Report generated by InsightElixir"
    end
 end
end
