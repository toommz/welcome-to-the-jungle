defmodule Wttj.Workers.CountryLocatorTest do
  use Wttj.DataCase

  describe "behavior" do
    setup do
      %{fct: &Wttj.Workers.CountryLocator.get_country_code/2}
    end

    test "accepts valid input", %{fct: fct} do
      assert fct.(48.1392154, 11.5781413) == {:ok, "de"}
    end

    test "only returns valid country codes", %{fct: fct} do
      assert fct.(0.0, 0.0) == {:error, false}
    end

    test "refuses invalid values", %{fct: fct} do
      assert_raise FunctionClauseError, fn ->
        fct.(nil, nil)
      end

      assert_raise FunctionClauseError, fn ->
        fct.(4, 5)
      end
    end
  end
end
