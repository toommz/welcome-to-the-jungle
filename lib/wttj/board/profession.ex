defmodule Wttj.Board.Profession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "professions" do
    field :category_name, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(profession, attrs) do
    profession
    |> cast(attrs, [:id, :name, :category_name])
    |> validate_required([:name, :category_name])
  end

  @doc """
  Creates a Profession given 3 primary attributes.

  ## Examples

    iex> {:ok, %Wttj.Board.Profession{id: 1, name: "Dev", category_name: "Tech"}} = Wttj.Board.Profession.create(1, "Dev", "Tech")
  """
  def create(id, name, category_name) do
    attrs = %{
      id: id,
      name: name,
      category_name: category_name
    }

    changeset(%__MODULE__{}, attrs)
    |> insert()
  end

  defp insert(%Ecto.Changeset{} = changeset) do
    changeset
    |> Wttj.Repo.insert(conflict_target: :id, on_conflict: :replace_all)
  end
end
