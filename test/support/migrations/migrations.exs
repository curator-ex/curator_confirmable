defmodule UsersMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string

      # Confirmable
      add :confirmed_at, :utc_datetime
      add :confirmation_token, :string
      add :confirmation_sent_at, :utc_datetime

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:confirmation_token])
  end
end
