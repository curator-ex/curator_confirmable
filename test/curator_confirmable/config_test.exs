defmodule CuratorConfirmable.ConfigTest do
  use ExUnit.Case, async: true
  doctest CuratorConfirmable.Config

  test "the repo" do
    assert CuratorConfirmable.Config.repo == CuratorConfirmable.Test.Repo
  end

  test "the user_schema" do
    assert CuratorConfirmable.Config.user_schema == CuratorConfirmable.Test.User
  end

  test "the token_expiration" do
    assert CuratorConfirmable.Config.token_expiration == [days: 1]
  end
end
