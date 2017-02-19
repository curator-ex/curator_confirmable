use Mix.Config

config :logger, level: :warn

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorConfirmable.Test.GuardianSerializer

config :curator_confirmable, CuratorConfirmable,
  repo: CuratorConfirmable.Test.Repo,
  user_schema: CuratorConfirmable.Test.User

config :curator_confirmable, ecto_repos: [CuratorConfirmable.Test.Repo]

config :curator_confirmable, CuratorConfirmable.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://localhost/curator_confirmable_test",
  size: 1,
  max_overflow: 0,
  priv: "test/support"
