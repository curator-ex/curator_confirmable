defmodule CuratorConfirmable.Hooks do
  @moduledoc """
  This module hooks into the curator lifecycle.
  """

  use Curator.Hooks

  def before_sign_in(user, _type) do
    CuratorConfirmable.active_for_authentication?(user)
  end
end
