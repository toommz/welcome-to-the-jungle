defmodule Wttj.Workers.ContinentLocator do
  @moduledoc """
  This GenServer will parse a list of corresponding countries and continents
  at runtime, and expose a main function to retrieve a continent name based
  on a two-letter country code.
  """
  use GenServer

  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    state =
      File.stream!("priv/vendor/country-and-continent-codes-list.csv")
      |> CSV.decode()
      |> Enum.drop(1)
      |> Enum.reduce(state, fn
        {:ok, [continent_name, _continent_code, _country_name, country_code, _country_code_extended, _country_number]}, acc ->
          key = String.downcase(country_code)
          value = continent_name

          Map.put_new(acc, key, value)

        err, acc ->
          Logger.error("[#{__MODULE__}]: Failed loading, received: #{inspect err}")
          acc
      end)

    {:ok, state}
  end

  def handle_call({:get_continent_name, country_code}, _from, state) do
    response = Map.get(state, country_code)

    {:reply, response, state}
  end

  @doc """
  Returns the associated continent_name given a two-letter country code.
  """
  def get_continent_name(country_code)
  def get_continent_name(nil), do: nil
  def get_continent_name(country_code) when is_binary(country_code) do
    country_code =
      country_code
      |> String.downcase()

    GenServer.call(__MODULE__, {:get_continent_name, country_code})
  end

  @doc """
  Returns the state of the GenServer.
  """
  def get_state() do
    :sys.get_state(__MODULE__)
  end
end
