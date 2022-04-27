defmodule Wttj.Workers.CountryLocator do
  @moduledoc """
  This module is responsible for identifying a location based on given
  latitude and longitude coordinates. It uses Geocoder and OpenStreetMaps
  API as a default backend (because, hey, it's free).

  Luckily, Geocoder caches its requests so we don't have to bother with cache.
  """

  def get_country_code(latitude, longitude) when is_float(latitude) and is_float(longitude) do
    with {:ok, coords} <- Geocoder.call({latitude, longitude}),
         %Geocoder.Coords{location: %Geocoder.Location{country_code: country_code}} <- coords do
      {:ok, country_code}
    else
      err -> {:error, err}
    end
  end
end
