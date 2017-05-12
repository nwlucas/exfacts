defmodule Facts.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exfacts,
      version: "0.1.2",
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.4",
      description: "A library for collection a variety of system facts.",
      source_url: "https://github.com/nwlucas/exfacts",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env:
        [
          "coveralls": :test,
          "coveralls.detail": :test,
          "coveralls.post": :test,
          "coveralls.html": :test
        ]
    ]
  end

  def application do
    [extra_applications: [:logger, :porcelain]]
  end

  defp package do
    [
      name: :exfacts,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nigel Williams-Lucas"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nwlucas/exfacts"}
    ]
  end

  defp deps do
    [
      {:logger_file_backend, "~> 0.0.9"},
      {:ex_doc, "~> 0.15.1", only: :dev},
      {:earmark, "~> 1.2.2", only: :dev},
      {:poison, "~> 3.0"},
      {:porcelain, "~> 2.0"},
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end
end
