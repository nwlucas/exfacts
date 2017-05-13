use Mix.Config

config :exfacts,
  etc_path: "/etc",
  proc_path: "/proc",
  sys_path: "/sys",
  cpuinfo: "cpuinfo",
  nproc: "nproc"

config :logger,
  backends: [:console],
  compile_time_purge_level: :info

config :porcelain, :driver, Porcelain.Driver.Basic

import_config "#{Mix.env}.exs"
