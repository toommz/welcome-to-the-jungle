defmodule Wttj.Board.JobTest do
  use Wttj.DataCase

  alias Wttj.Board.Job
  alias Wttj.Board.Profession

  setup do
    professions = [
      Profession.create(1, "Entrepreneur", "Healthcare") |> elem(1)
    ]
    %{professions: professions}
  end

  describe "create/5" do
    test "simple assertions", %{professions: [profession]} do
      expected_errors = [
        contract_type: {"can't be blank", [validation: :required]},
        name: {"can't be blank", [validation: :required]}
      ]

      {:error, %Ecto.Changeset{errors: errors}} = Wttj.Board.Job.create(nil, nil, nil, nil, nil)

      assert errors == expected_errors

      {:ok, _job} = Job.create(nil, "TEMPORARY", "Cook", 0, 0)
      {:ok, job} = create_some_job(profession)

      assert job.profession_id == profession.id
      assert job.contract_type == "PERMANENT"
      assert job.name == "Cook"
      assert job.office_latitude == Decimal.from_float(-10.0)
      assert job.office_longitude == Decimal.from_float(-100.234)
      assert is_nil(job.office_continent_name)
    end
  end

  describe "update/2" do
    test "simple assertions", %{professions: [profession]} do
      {:ok, job} = create_some_job(profession)

      {:ok, %Job{office_continent_name: "Asia"}} = Job.update(job.id, "Asia")
    end
  end

  defp create_some_job(%Profession{id: id}) do
    Job.create(id, "PERMANENT", "Cook", -10.0, -100.234)
  end
end
