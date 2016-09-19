# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :time_tracker_backend,
  ecto_repos: [TimeTrackerBackend.Repo]

# Configures the endpoint
config :time_tracker_backend, TimeTrackerBackend.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EBNMtcm9U8qY1vCPcfhtMly4e2KuCO0VtfEiFP09H05ChwRxgRA4meE9hQZNYRdI",
  render_errors: [view: TimeTrackerBackend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TimeTrackerBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["ES512"], # optional
  verify_module: Guardian.JWT,  # optional
  verify_issuer: true, # optional
  issuer: "TimeTrackerBackend",
  #ttl: { 30, :days },
  ttl: { 15, :seconds },
  secret_key: fn ->
    JOSE.JWK.from_pem_file("ec-secp521r1.pem")
  end,
  serializer: TimeTrackerBackend.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
