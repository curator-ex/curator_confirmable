defmodule CuratorConfirmableTest do
  use ExUnit.Case
  doctest CuratorConfirmable

  use CuratorConfirmable.TestCase

  setup do
    changeset = User.changeset(%User{}, %{
      name: "Test User",
      email: "test_user@test.com",
    })

    user = Repo.insert!(changeset)

    { :ok, %{
        user: user,
      }
    }
  end

  test "set_confirmation_token!", %{user: user} do
    {user, token} = CuratorConfirmable.set_confirmation_token!(user)

    assert user.confirmation_token == token
    assert user.confirmation_sent_at
  end

  test "confirm!", %{user: user} do
    {user, _token} = CuratorConfirmable.set_confirmation_token!(user)

    refute user.confirmed_at

    user = CuratorConfirmable.confirm!(user)

    assert user.confirmed_at
    refute user.confirmation_token
    refute user.confirmation_sent_at
  end

  test "active_for_authentication? with a non-confirmed user" do
    user = %{confirmed_at: nil}
    {:error, "Not Confirmed"} = CuratorConfirmable.active_for_authentication?(user)
  end

  test "active_for_authentication? with a confirmed user" do
    user = %{confirmed_at: Timex.now}
    :ok = CuratorConfirmable.active_for_authentication?(user)
  end
end
