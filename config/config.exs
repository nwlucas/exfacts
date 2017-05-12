use Mix.Config

config :logger,
  backends: [:console],
  compile_time_purge_level: :info

config :porcelain, :driver, Porcelain.Driver.Basic

import_config "#{Mix.env}.exs"
