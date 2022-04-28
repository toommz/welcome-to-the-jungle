defmodule WttjWeb.Parameters do
  import Ecto.Query

  alias Wttj.Board.Report

  # @TODO: Should put that in a Spex Schema
  @allowed_filters [
    :category_name,
    :continent_name
  ]

  def apply_filter(queryable, %{params: params}) do
    Enum.reduce(params, queryable, fn {key, value}, acc ->
      key_atom = String.to_existing_atom(key)

      if Enum.find(@allowed_filters, fn x -> x == key_atom end) |> is_nil() == false do
        Report.QueryBuilding.filter(acc, key_atom, value)
      else
        acc
      end
    end)
  end
  def apply_filter(queryable, _conn), do: queryable

  def apply_sort(queryable, %{params: %{"sort" => sort}}) do
    order_by_column =
      case sort do
        "-" <> field ->
          {:desc, String.to_existing_atom(field)}

        field ->
          {:asc, String.to_existing_atom(field)}
      end

    queryable
    |> exclude(:order_by)
    |> order_by(^order_by_column)
  end
  def apply_sort(queryable, _conn), do: queryable
end
