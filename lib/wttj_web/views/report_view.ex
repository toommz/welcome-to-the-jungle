defmodule WttjWeb.ReportView do
  use WttjWeb, :view

  alias Wttj.Board.Report

  def render("reports.json", %{reports: reports}) do
    reports |> Enum.map(fn r -> render("report.json", %{report: r}) end)
  end

  def render("report.json", %{report: %Report{} = report}) do
    %{
      category_name: report.category_name,
      continent_name: report.continent_name,
      jobs_count: report.jobs_count
    }
  end
end
