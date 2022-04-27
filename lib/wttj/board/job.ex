defmodule Wttj.Board.Job do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :contract_type,
    :name
  ]
  @all_fields @required_fields ++ [
    :profession_id,
    :office_latitude,
    :office_longitude,
    :office_continent_name
  ]

  schema "jobs" do
    field :contract_type, :string
    field :name, :string
    field :office_latitude, :decimal
    field :office_longitude, :decimal
    field :office_continent_name, :string

    field :profession_id, :id

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end

  def create(profession_id, contract_type, name, office_latitude, office_longitude) do
    attrs = %{
      profession_id: profession_id,
      contract_type: contract_type,
      name: name,
      office_latitude: office_latitude,
      office_longitude: office_longitude,
    }

    changeset(%__MODULE__{}, attrs)
    |> insert()
  end

  def update(id, office_continent_name) do
    {:ok, job} = Wttj.Repo.get(__MODULE__, id)
    changeset = Ecto.Changeset.change(job, office_continent_name: office_continent_name)

    Wtj.Repo.update(changeset)
  end

  defp insert(%Ecto.Changeset{} = changeset) do
    changeset
    |> Wttj.Repo.insert()
  end
end
