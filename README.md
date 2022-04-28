# Welcome to the Jungle - Technical Test

## Prerequisites
You'll need:
* Docker and Docker Compose
* Erlang and Elixir installed (if you got ASDF and plugins, you can just run `asdf install` to get the versions I used)
* A free 5432 port :-)

You can then run:
```sh
# Start a postgres server:
docker-compose up -d
# Get dependencies
mix deps.get
# Create, migrate and seed the database (it'll take a while, but less than 2 minutes):
mix ecto.setup
# Run tests
mix test
```

## Codebase Overview
Provided files are located in the `priv/vendor` folder, along with a list of countries featuring country data.

The `professions` schema is basically untouched. However, I added an `office_continent_name` to the `jobs` schema, so that we can compute the value and store it. Countries are kind of a "static" data that don't evolve much overtime, and we want to avoid sending requests to an API each time we want to group jobs by categories and continents.

The most relevant code is located in `lib/wttj/workers`. There's no common interface but I tried to think of them as individual Command implementations.

## Part One
Run the report task:
```sh
mix wttj.report
```

It should output something like this:
```
Admin Jobs in continent Asia: 1
Admin Jobs in continent Europe: 396
Admin Jobs in continent North America: 9
Business Jobs in continent Africa: 3
Business Jobs in continent Asia: 30
Business Jobs in continent Europe: 1372
Business Jobs in continent North America: 27
Business Jobs in continent South America: 4
Conseil Jobs in continent Europe: 175
Créa Jobs in continent Europe: 205
Créa Jobs in continent North America: 7
Marketing / Comm' Jobs in continent Africa: 1
Marketing / Comm' Jobs in continent Asia: 3
Marketing / Comm' Jobs in continent Europe: 759
Marketing / Comm' Jobs in continent North America: 12
Marketing / Comm' Jobs in continent Oceania: 1
Retail Jobs in continent Africa: 1
Retail Jobs in continent Asia: 6
Retail Jobs in continent Europe: 426
Retail Jobs in continent North America: 93
Retail Jobs in continent Oceania: 2
Tech Jobs in continent Africa: 3
Tech Jobs in continent Asia: 11
Tech Jobs in continent Europe: 1402
Tech Jobs in continent North America: 14
Tech Jobs in continent South America: 1
4965 Jobs in total
```

## Part Two
### Database Seed
:warning: This part may be overkill.

* I assume that the Database Seed wouldn't be 100 millions lines long. But if it was the case, the current linear processing I do should be reworked to process batches and in parallel (currently it's O(n)). IDs should probably be pregenerated as well. The procedure could go like this:
  * Streaming input, but processing each time a batch is complete
  * Using Ecto `insert_all` function with the `placeholders` option (especially for timestamps)
* My current implementation is simple as I assume no one would want a seed that would kill a developer laptop, so I didn't overengineered it :-)

### Actual runtime
* A table with 100 million rows may be a bit slow to update, but I assume the following architecture would be enough:
  * A table (`categories_continents_counts`) matching categories and continents with precomputed count fields (exactly the structure of the report).
  * Each Job would still have the computed field `office_continent_name` I added (or a PG View instead of the table directly)
  * On Job creation or coordinates update, I would enqueue an actual Job (with Oban) to compute that value
    * That value would be fetched from a local cache (a Postgres table matching coordinates and continent names), OR from an API
    * That value would be used for historical reasons and recomputing (in case cache counters would be lost or considered no longer reliable)
    * The Oban Job would also increase the relevant count in table `categories_continents_counts`.

If hitting an external API for reverse geocoding would be a problem, then I would go to process every possible latitude and longitude combination and store it before deployment. With scheduled updates if countries information do change (borders, etc.).

If we really want real-time reporting, then the Oban worker should be able to broadcast a Phoenix Channel event, so that the updated count is carried over through WebScokets.

If the information is only relevant for internal business purposes, I would probably engineer or handover to a data warehouse, and use something like BigQuery to present the data with internal dashboarding.

## Part Three
Make sure you got some data:
```sh
mix ecto.setup
```

Start the application server:
```
iex -S mix phx.server
# Compute Reports:
iex> Wttj.Workers.ReportUpdater.run()
```

And you can then access your app at `localhost:4000/reports`

### API Documentation
There's a rudimentory OpenAPI documentation available. You can generate it and import it in, eg. Postman:
```sh
mix apidoc
```

* You can filter category and continent names
* You can sort by each three fields (regular field name for ascending, preceded with a minus sign for descending)
* Only one sortable field at a time is allowed

### Examples
* `http://localhost:4000/reports?category_name=Tech&continent_name=Europe`
* `http://localhost:4000/reports?category_name=Tech&sort=-jobs_count`
* `http://localhost:4000/reports?category_name=Tech&continent_name=Africa&sort=-jobs_count`
