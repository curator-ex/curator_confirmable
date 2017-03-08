defmodule CuratorConfirmable.Schema do
  @moduledoc """
  """

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)

      def confirmable_changeset(user, params \\ %{}) do
        user
        |> cast(params, curator_confirmable_fields)
      end

      def curator_confirmable_fields do
        ~w(confirmed_at confirmation_token confirmation_sent_at)a
      end

      defoverridable [
        {:confirmable_changeset, 2},
        {:curator_confirmable_fields, 0},
      ]
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
