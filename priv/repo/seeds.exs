# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Wttj.Repo.insert!(%Wttj.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger

File.stream!("priv/vendor/technical-test-professions.csv")
|> CSV.decode()
|> Enum.drop(1)
|> Enum.each(fn
  {:ok, [id, name, category_name]} ->
    result = Wttj.Board.Profession.create(id, name, category_name)

    case result do
      {:ok, record} ->
        Logger.debug("[SEED] Successfully imported Profession ID #{record.id}")
      _ ->
        Logger.error("[SEED] Couldn't import Profession ID #{id}")
    end
  _ ->
    Logger.error("[SEED] Skipping a malformed Profession row.")
end)



File.stream!("priv/vendor/technical-test-jobs.csv")
|> CSV.decode()
|> Enum.drop(1)
|> Enum.each(fn
  {:ok, [profession_id, contract_type, name, office_latitude, office_longitude]} ->
    result = Wttj.Board.Job.create(profession_id, contract_type, name, office_latitude, office_longitude)

    case result do
      {:ok, _} ->
        Logger.debug("[SEED] Successfully imported Job #{name}")
      err ->
        Logger.error("[SEED] Couldn't import Job #{name} #{inspect err}")
    end
  _ ->
    Logger.error("[SEED] Skipping a malformed Job row.")
end)
