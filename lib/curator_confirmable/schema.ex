defmodule CuratorConfirmable.Schema do
  @moduledoc """
  """

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro curator_confirmable_schema do
    quote do
      field :confirmed_at, Timex.Ecto.DateTime
      field :confirmation_token, :string
      field :confirmation_sent_at, Timex.Ecto.DateTime
    end
  end
end
