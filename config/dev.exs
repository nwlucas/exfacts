use Mix.Config

config :logger,
  backends: [{LoggerFileBackend, :log}],
  handle_sasl_reports: true

config :logger, :log,
  path: "logs/#{Mix.env}.log",
  level: :info
