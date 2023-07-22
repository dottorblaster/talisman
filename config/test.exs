import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :talisman, Talisman.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "talisman_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :talisman, TalismanWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "I/fe6ptEaivaI5uBTqk/BjUrkaNaUebDxaaxvWdDSb5iqhYldT1L/fsFhRKyd6gt",
  server: false

# In test we don't send emails.
config :talisman, Talisman.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :talisman, Talisman.EventStore,
  serializer: EventStore.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "talisman_eventstore_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost"
