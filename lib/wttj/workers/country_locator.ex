defmodule Wttj.Workers.CountryLocator do
  @moduledoc """
  This module is responsible for identifying a location based on given
  latitude and longitude coordinates. It uses Geocoder and OpenStreetMaps
  API as a default backend (because, hey, it's free).

  Luckily, Geocoder caches its requests so we don't have to bother with cache.
  """

  require Logger

  @doc """
  Returns a two-letter country code given a latitude and longitude.
  """
  def get_country_code(latitude, longitude)
  def get_country_code(%Decimal{} = latitude, %Decimal{} = longitude) do
    call_api(
      latitude |> Decimal.to_float(),
      longitude |> Decimal.to_float()
    )
  end
  def get_country_code(latitude, longitude) when is_float(latitude) and is_float(longitude) do
    call_api(latitude, longitude)
  end

  defp call_api(latitude, longitude) do
    with {:ok, coords} <- Geocoder.call({latitude, longitude}),
         %Geocoder.Coords{location: %Geocoder.Location{country_code: country_code}} <- coords,
         true <- is_binary(country_code) do
      {:ok, country_code}
    else
      err -> {:error, err}
    end

  rescue
    err ->
      Logger.error("[#{__MODULE__}]: Caught #{inspect err}")
      {:error, err}
  end
end
