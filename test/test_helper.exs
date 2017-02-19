Code.require_file "test/support/migrations/migrations.exs"

alias CuratorConfirmable.Test.Repo

defmodule CuratorConfirmable.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias CuratorConfirmable.Test.Repo
      alias CuratorConfirmable.Test.User
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end
end

_   = Ecto.Adapters.Postgres.storage_down(Repo.config)
:ok = Ecto.Adapters.Postgres.storage_up(Repo.config)
{:ok, _pid} = Repo.start_link
Ecto.Migrator.up(Repo, 0, UsersMigration, log: false)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)
