defmodule Wttj.Workers.ReportUpdater do
  @moduledoc """
  Updates Jobs office continent names and updates the reports table.
  """
  alias Wttj.Board.Report

  def run() do
    Wttj.Workers.OfficeContinentNameUpdater.run()

    with %Postgrex.Result{rows: rows} <- Wttj.Board.jobs_per_continent_and_category() do
      to_process =
        totals_per_continent(rows)
        |> Kernel.++(totals_per_category(rows))
        |> Kernel.++(total_overall(rows))
        |> Kernel.++(rows)

      process(to_process)
    else
      err ->
        IO.puts "Oops... Something bad happened: #{inspect err}"
    end
  end

  # @TODO: `inserted_at` is lost on each upsert.
  defp process(rows) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    entries =
      rows
      |> Enum.map(fn [category_name, jobs_count, continent_name] ->
        %{
          category_name: category_name,
          continent_name: continent_name,
          jobs_count: jobs_count,
          inserted_at: now,
          updated_at: now
        }
      end)

    Wttj.Repo.insert_all(
      Report,
      entries,
      conflict_target: [:category_name, :continent_name],
      on_conflict: :replace_all
    )
  end

  defp totals_per_continent(rows) do
    rows
    |> Enum.group_by(fn [_cat, _count, cont] -> cont end, fn [_cat, count, _cont] -> count end)
    |> Enum.map(fn {continent, v} -> ["TOTAL", Enum.sum(v), continent] end)
  end

  defp totals_per_category(rows) do
    rows
    |> Enum.group_by(fn [cat, _count, _cont] -> cat end, fn [_cat, count, _cont] -> count end)
    |> Enum.map(fn {category, v} -> [category, Enum.sum(v), "TOTAL"] end)
  end

  defp total_overall(rows) do
    total_overall =
      rows |> Enum.reduce(0, fn [_cat, count, _cont], acc -> acc + count end)

    [["TOTAL", total_overall, "TOTAL"]]
  end
end
