defmodule Wttj.BoardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wttj.Board` context.
  """

  @doc """
  Generate a profession.
  """
  def profession_fixture(attrs \\ %{}) do
    {:ok, profession} =
      attrs
      |> Enum.into(%{
        category_name: "some category_name",
        name: "some name"
      })
      |> Wttj.Board.create_profession()

    profession
  end
end
