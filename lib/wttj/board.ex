defmodule Wttj.Board do
  @moduledoc """
  General context around Jobs and Professions.
  """

  def jobs_per_continent_and_category() do
    """
      SELECT
        p1.category_name,
        count(j0.id),
        j0.office_continent_name
      FROM
        jobs j0
        INNER JOIN professions as p1 ON j0.profession_id = p1.id
      WHERE
        j0.profession_id IS NOT NULL AND j0.office_continent_name IS NOT NULL
      GROUP BY
        j0.office_continent_name, p1.category_name;
    """
    |> Wttj.Repo.query!()
  end
end
