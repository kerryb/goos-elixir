defmodule AuctionSniper.MixProject do
  use Mix.Project

  def project do
    [
      app: :auction_sniper,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  @xmpp_hostname "localhost"
  @sniper_id "sniper"
  @sniper_password "sniper"
  @auction_id "auction-54321"

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {AuctionSniper, [@xmpp_hostname, @sniper_id, @sniper_password, @auction_id]},
      extra_applications: [:logger, :crypto, :observer, :wx, :runtime_tools, :romeo, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:romeo, git: "https://github.com/kerryb/romeo.git", branch: "main"},
      {:scenic, "~> 0.11.0"},
      {:scenic_driver_local, "~> 0.11.0"},
      {:styler, "~> 0.10", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [test: "test --no-start"]
  end
end
