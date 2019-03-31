defmodule GameApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_api,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GameApi.Application, []},
      extra_applications: [:logger, :runtime_tools, :mongodb_ecto, :ecto, :ex_machina]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:ci), do: ["lib", "test"]
  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.2"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:ecto, "~> 2.1"},
      {:mongodb_ecto, "~> 0.2"},
      {:mox, "~>0.5", only: [:test, :ci]},
      {:ex_machina, "~> 2.2"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test, :ci], runtime: false}
    ]
  end
end
