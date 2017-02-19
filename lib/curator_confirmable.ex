defmodule CuratorConfirmable do
  @moduledoc """
  CuratorConfirmable: A curator module to handle user "confirmation".
  """

  if !(
       (Application.get_env(:curator_confirmable, CuratorConfirmable) && Keyword.get(Application.get_env(:curator_confirmable, CuratorConfirmable), :repo)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :repo))
      ), do: raise "CuratorConfirmable requires a repo"

  if !(
       (Application.get_env(:curator_confirmable, CuratorConfirmable) && Keyword.get(Application.get_env(:curator_confirmable, CuratorConfirmable), :user_schema)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :user_schema))
      ), do: raise "CuratorConfirmable requires a user_schema"

  alias CuratorConfirmable.Config

  def confirmed?(user) do
    case user.confirmed_at do
      nil -> false
      _ -> true
    end
  end

  def confirm!(user) do
    user
    |> Ecto.Changeset.change(confirmed_at: Timex.now)
    |> clear_confirmation_info_changeset
    |> Config.repo.update!
  end

  def active_for_authentication?(resource) do
    case confirmed?(resource) do
      true -> :ok
      false -> {:error, "Not Confirmed"}
    end
  end

  def clear_confirmation_info_changeset(changeset) do
    Ecto.Changeset.change(changeset, confirmation_token: nil, confirmation_sent_at: nil)
  end

  def set_confirmation_token!(user) do
    confirmation_token = Curator.Token.generate
    confirmation_sent_at = Timex.now

    user = user
    |> Ecto.Changeset.change(confirmation_token: confirmation_token, confirmation_sent_at: confirmation_sent_at)
    |> Config.repo.update!

    {user, confirmation_token}
  end

  def confirmation_token_expired?(%{confirmation_sent_at: confirmation_sent_at}) do
    Curator.Time.expired?(confirmation_sent_at, Config.token_expiration)
  end

  def request_confirmation_email_changeset(data, params \\ %{}) do
    import Ecto.Changeset
    types = %{email: :string}

    {data, types}
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
