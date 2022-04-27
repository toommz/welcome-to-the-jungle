defmodule Wttj.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :contract_type, :string
      add :name, :string
      add :office_latitude, :decimal
      add :office_longitude, :decimal

      add :office_continent_name, :string

      add :profession_id, references(:professions, on_delete: :nothing)

      timestamps()
    end

    create index(:jobs, [:profession_id, :office_continent_name])
  end
end
