use Mix.Config

config :logger, compile_time_purge_level: :info
config :porcelain, :driver, Porcelain.Driver.Basic
