# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wttj,
  ecto_repos: [Wttj.Repo]

# Configures the endpoint
config :wttj, WttjWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "w2tn274ZTn5Bmk2hMILnP0DJ5bhNJaSBs1WztIr89Rj1u+xd17/7yXqd/LSnb1Eo",
  render_errors: [view: WttjWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Wttj.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
