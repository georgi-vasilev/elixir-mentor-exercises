defmodule InsightElixir.AnalyticsReport do
  @moduledoc """
  some docs for the reporting lopgic
  """

  import InsightElixir.Utilities, only: [format_date: 1]
  alias InsightElixir.ReportMacros
  alias Calculations.EngagementCalculator, as: Calc
  require InsightElixir.ReportMacros
  use InsightElixir.ReportSetup

  @constant_value 22

  # generate_report /2
  def generate_report(:user_engagement, :weekly) do
    formatted_date = format_date(DateTime.utc_now())
    "user engagement weekly report for #{formatted_date} generated."
  end

  # generate_report /2
  def generate_report(:sales, :monthly) do
    engagement_cals = Calc.calculate_engagement()
    "sales monthly report generated. #{engagement_cals}"
  end

  # generate_report /2
  def generate_report(:traffic, range = %{from: _, to: _}) do
    "traffic report generated for range #{range[:from]}."
  end


  # generate_report /1
  def generate_report(:user_engagement) do
    ReportMacros.log_report_generation(:user_engagement)
    #"user engagement report generated."
  end

  # generate_report /1
  def generate_report(:sales) do
    header()
    #"sales report generated."
  end

  # generate_report /1
  def generate_report(:traffic) do
    "traffic report generated."
  end

  # generate_report /0
  def generate_report(_) do
    "Default report generated."
  end

  def short_generate_report, do: "Default report short hand"
end
