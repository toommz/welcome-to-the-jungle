# Just here to silence DIalyzer warning.
defmodule WttjWeb.ReportController do
  use WttjWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Wttj.Board.Report

  operation :index,
    summary: "Get Job reports",
    parameters: [
      category_name: [in: :query, description: "Category Name", type: :string, example: "Tech"],
      continent_name: [in: :query, description: "Continent Name", type: :string, example: "Europe"]
    ] ++ [%OpenApiSpex.Parameter{name: :sort, in: :query, schema: WttjWeb.Schema.SortParams}],
    responses: [
      # ok: {"Report response", "application/json", WttjWeb.Schema.ReportResponse}
    ]

  def index(conn, _params) do
    reports =
      Report
      |> WttjWeb.Parameters.apply_filter(conn)
      |> WttjWeb.Parameters.apply_sort(conn)
      |> Report.all()

    conn
    |> put_view(WttjWeb.ReportView)
    |> render("reports.json", %{reports: reports})
  end
end
