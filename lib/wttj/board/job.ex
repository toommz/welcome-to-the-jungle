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
    field :contract_type, :string # @TODO: Use an EctoEnum here.
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

  @doc """
  Creates a Job given 5 primary attributes.
  """
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

  @spec update(integer, binary) :: {:ok, struct} | {:error, any}
  @doc """
  Updates a Job office_continent_name field given an ID.
  """
  def update(id, office_continent_name) when is_integer(id) and is_binary(office_continent_name) do
    with %__MODULE__{} = job <- Wttj.Repo.get(__MODULE__, id) do
      changeset = Ecto.Changeset.change(job, office_continent_name: office_continent_name)
      Wttj.Repo.update(changeset)
    else
      err -> {:error, err}
    end
  end

  defp insert(%Ecto.Changeset{} = changeset) do
    changeset
    |> Wttj.Repo.insert()
  end
end
