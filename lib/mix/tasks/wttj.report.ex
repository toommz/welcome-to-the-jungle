defmodule Mix.Tasks.Wttj.Report do
  use Mix.Task
  require Mix.Generator

  def run(_argv) do
    Mix.Task.run("app.start")

    Wttj.Workers.OfficeContinentNameUpdater.run()

    with %Postgrex.Result{rows: rows} <- Wttj.Board.jobs_per_continent_and_category() do
      rows
      |> Enum.reduce(%{}, fn [category, count, continent], acc ->
        Map.put_new(acc, {category, continent}, count)
      end)
      |> Enum.each(fn {{category, continent}, count} ->
        IO.puts "#{category} Jobs in continent #{continent}: #{count}"
      end)
    else
      err ->
        IO.puts "Oops... Something bad happened: #{inspect err}"
    end

  end
end
