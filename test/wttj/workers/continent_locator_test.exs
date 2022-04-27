defmodule Wttj.Workers.ContinentLocatorTest do
  use Wttj.DataCase

  describe "behavior" do
    setup do
      %{fct: &Wttj.Workers.ContinentLocator.get_continent_name/1}
    end

    test "accepts valid input", %{fct: fct} do
      assert fct.("fr") == "Europe"
    end

    test "returns nil on unknown values", %{fct: fct} do
      assert fct.(nil) == nil
      assert fct.("FRA") == nil
    end

    test "is case insensitive", %{fct: fct} do
      assert fct.("FR") == "Europe"
      assert fct.("Gb") == "Europe"
      assert fct.("gB") == "Europe"
    end
  end


end
