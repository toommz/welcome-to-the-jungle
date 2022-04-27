defmodule Wttj.Workers.OfficeContinentNameUpdater do
  @moduledoc """
  Exposes a `run/0` function that will query all Jobs that don't have
  an office_continent_name field set yet, to process them.
  """
  import Ecto.Query

  require Logger

  alias Wttj.Board.Job

  @parallel_options [num_workers: 8]

  def run() do
    get_unlocated_jobs() |> process()
  end

  def get_unlocated_jobs() do
    Job
    |> where([j], is_nil(j.office_continent_name))
    |> where([j], is_nil(j.office_latitude) == false)
    |> where([j], is_nil(j.office_longitude) == false)
    |> Wttj.Repo.all()
  end

  defp process([]), do: {:ok, :nothing_to_do}
  defp process(jobs) do
    jobs
    |> ParallelStream.map(&(update_job/1), @parallel_options)
    |> Enum.into([])
  end

  defp update_job(%Job{id: id, office_latitude: lat, office_longitude: long} = job) do
    with {:ok, country_code} <- Wttj.Workers.CountryLocator.get_country_code(lat, long) do
      continent_name = Wttj.Workers.ContinentLocator.get_continent_name(country_code)

      if is_binary(continent_name) do
        with {:ok, updated_job} <- Job.update(id, continent_name) do
          updated_job
        else
          _ ->
            Logger.warning("[UPDATER] Was unable to update Job ID #{id}")
            job
        end
      end
    end
  end
end
