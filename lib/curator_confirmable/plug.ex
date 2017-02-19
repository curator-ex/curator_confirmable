defmodule CuratorConfirmable.Plug do
  @moduledoc """
  """
  # import Plug.Conn

  def init(opts \\ %{}) do
    opts = Enum.into(opts, %{})

    %{
      key: Map.get(opts, :key, Curator.default_key),
    }
  end

  def call(conn, opts) do
    key = Map.get(opts, :key)

    case Curator.PlugHelper.current_resource(conn, key) do
      nil -> conn
      {:error, _error} -> conn
      current_resource ->
        case CuratorConfirmable.active_for_authentication?(current_resource) do
          :ok -> conn
          {:error, error} -> Curator.PlugHelper.clear_current_resource_with_error(conn, error, key)
        end
    end
  end
end
