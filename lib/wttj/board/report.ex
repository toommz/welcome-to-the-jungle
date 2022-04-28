defmodule Wttj.Board.Report do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "reports" do
    field :category_name, :string
    field :continent_name, :string
    field :jobs_count, :integer

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:category_name, :continent_name, :jobs_count])
    |> validate_required([:category_name, :continent_name, :jobs_count])
  end

  defmodule QueryBuilding do
    import Ecto.Query

    def filter(query, :category_name, value) do
      query |> where([r], r.category_name == ^value)
    end

    def filter(query, :continent_name, value) do
      query |> where([r], r.continent_name == ^value)
    end
  end

  def all(query \\ __MODULE__) do
    Wttj.Repo.all(query)
  end
end
