defmodule CuratorConfirmable.Test.Repo do
  use Ecto.Repo, otp_app: :curator_confirmable

  def log(_cmd), do: nil
end
