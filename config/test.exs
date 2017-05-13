use Mix.Config

config :exfacts,
  etc_path: __DIR__ <> "/../test/files/etc",
  proc_path: __DIR__ <> "/../test/files/proc",
  sys_path: __DIR__ <> "/../test/files/sys",
  cpuinfo: "cpuinfo_test"
