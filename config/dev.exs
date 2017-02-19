use Mix.Config

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorConfirmable.Test.GuardianSerializer

config :curator_confirmable, CuratorConfirmable,
  repo: CuratorConfirmable.Test.Repo,
  user_schema: CuratorConfirmable.Test.User

# config :curator_confirmable, ecto_repos: [CuratorConfirmable.Test.Repo]

# config :curator_confirmable, CuratorConfirmable.Test.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "",
#   database: "curator_confirmable_dev",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox,
#   priv: "test/support"
