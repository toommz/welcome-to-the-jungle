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

  def all() do
    Wttj.Repo.all(__MODULE__)
  end
end
