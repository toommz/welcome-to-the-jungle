defmodule WttjWeb.Schema.SortParams do
  require WttjWeb.ApiSpec

  WttjWeb.ApiSpec.sort_schema [
    :category_name,
    :jobs_count,
    :continent_name
  ]
end
