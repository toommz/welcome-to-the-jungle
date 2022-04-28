defmodule Mix.Tasks.Wttj.Report do
  use Mix.Task
  require Mix.Generator

  alias Wttj.Board.Report

  def run(_argv) do
    Mix.Task.run("app.start")

    Wttj.Workers.ReportUpdater.run()

    Report.all()
    |> Enum.each(fn %Report{category_name: category_name, continent_name: continent_name} = report ->
      IO.puts "#{report.jobs_count} Jobs (Category #{category_name}, Continent #{continent_name})"
    end)

  end
end
