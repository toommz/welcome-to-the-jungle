defmodule Wttj.Workers.OfficeContinentNameUpdaterTest do
  use Wttj.DataCase

  alias Wttj.Board.Job

  describe "behavior" do
    setup do
      %{fct: &Wttj.Workers.OfficeContinentNameUpdater.run/0}
    end

    test "doesn't run when there's not enough data", %{fct: fct} do
      assert fct.() == {:ok, :nothing_to_do}

      {:ok, _job} = Job.create(nil, "TEMPORARY", "Dev", nil, nil)
      {:ok, _job} = Job.create(nil, "TEMPORARY", "Dave Lauper", 0.0, nil)
      assert fct.() == {:ok, :nothing_to_do}
    end

    test "doesn't run when there's nothing to update", %{fct: fct} do
      {:ok, job} = Job.create(nil, "TEMPORARY", "Dave Lauper", 0.0, 0.0)
      {:ok, _job} = Job.update(job.id, "Mars")
      assert fct.() == {:ok, :nothing_to_do}
    end

    test "updates data", %{fct: fct} do
      Job.create(nil, "TEMPORARY", "Dave Lauper", 48.1392154, 11.5781413)
      [%Job{office_continent_name: "Europe"}] = fct.()
    end
  end


end
