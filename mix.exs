defmodule BraccoPubSub.MixProject do
  use Mix.Project

  def project do
    [
      app: :bracco_pub_sub,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BraccoPubSub.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.14.0"},
      {:jason, "~> 1.1"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
