defmodule CuratorConfirmable.Mixfile do
  use Mix.Project

  def project do
    [app: :curator_confirmable,
     version: "0.1.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps,
     dialyzer: [plt_add_deps: :transitive],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [applications: _applications(Mix.env)]
  end

  defp _applications(:test), do: [:postgrex, :ecto, :logger, :timex, :timex_ecto, :tzdata]
  defp _applications(_), do: [:logger, :timex, :timex_ecto, :tzdata]

  defp deps do
    [
      {:curator, github: "curator-ex/curator"},
      {:ecto, "~> 2.0"},
      {:plug, "~> 1.2"},
      {:postgrex, ">= 0.11.1", optional: true},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"},

      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    ["test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
