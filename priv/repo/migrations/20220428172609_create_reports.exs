defmodule Wttj.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports, primary_key: false) do
      add :category_name, :string, primary_key: true
      add :continent_name, :string, primary_key: true
      add :jobs_count, :integer

      timestamps()
    end

    create index(:reports, [:jobs_count])
  end
end
