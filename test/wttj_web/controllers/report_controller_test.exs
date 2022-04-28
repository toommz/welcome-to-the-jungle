defmodule WttjWeb.Controllers.ReportControllerTest do
  use WttjWeb.ConnCase

  alias Wttj.Board.Report

  describe "without data" do
    test "returns a 200", %{conn: conn} do
      conn
      |> get("/reports")
      |> json_response(200)
    end
  end

  describe "with data" do
    setup do
      template = %{
        inserted_at: {:placeholder, :now},
        updated_at: {:placeholder, :now}
      }

      placeholders = %{
        now: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }

      reports = [
        %{category_name: "Tech", continent_name: "Europe", jobs_count: 1},
        %{category_name: "Tech", continent_name: "Asia", jobs_count: 2},
        %{category_name: "Tech", continent_name: "Africa", jobs_count: 3},
        %{category_name: "Admin", continent_name: "Africa", jobs_count: 4}
      ]
      |> Enum.map(fn report -> Map.merge(report, template) end)

      Wttj.Repo.insert_all(Report, reports, placeholders: placeholders)
      :ok
    end

    test "returns a 200", %{conn: conn} do
      conn
      |> get("/reports")
      |> json_response(200)
    end

    test "applies two filters", %{conn: conn} do
      response =
        conn
        |> get("/reports?category_name=Tech&continent_name=Europe")
        |> json_response(200)

      response
      |> Enum.map(&(&1["category_name"]))
      |> Enum.uniq()
      |> Kernel.==(["Tech"])
      |> assert()
    end

    test "applies a sort, jobs_count", %{conn: conn} do
      response =
        conn
        |> get("/reports?sort=jobs_count")
        |> json_response(200)

      response2 =
        conn
        |> get("/reports?sort=-jobs_count")
        |> json_response(200)

      refute response == []
      refute response2 == []

      response
      |> Enum.reverse()
      |> Kernel.==(response2)
      |> assert()
    end
  end
end
