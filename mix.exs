defmodule BraccoPubSub.MixProject do
  use Mix.Project

  def project do
    [
      app: :bracco_pub_sub,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BraccoPubSub.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.14.0"},
      {:jason, "~> 1.1"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:plug_cowboy, "~> 2.0"},
      {:distillery, "~> 2.0"},
      {:uuid, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
