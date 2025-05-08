defmodule KinoTermite.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :kino_termite,
      description: "Termite adapter for Livebook",
      package: package(),
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Kino Termite",
      source_url: "https://github.com/Gazler/kino_termite",
      docs: [
        source_ref: "v#{@version}"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENCE.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Gazler/kino_termite"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.15.0"},
      {:termite, "~> 0.3.0"}
    ]
  end
end
