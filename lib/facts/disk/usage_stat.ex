defmodule Facts.Disk.UsageStat do
  @moduledoc """
    Provides a struct to hold usage data.

    ##Examples

      iex> u = %UsageStat{path: "/", used_persent: "14"}
      ...> u.path
      "/"
  """
  @derive [Poison.Encoder]

  @type t :: %Facts.Disk.UsageStat{
    path: binary,
    fs_type: binary,
    total: float,
    free: float,
    used: float,
    used_percent: float,
    inodes_total: float,
    inodes_used: float,
    inodes_free: float,
    inodes_used_percent: float
  }

  defstruct [
    path: "",
    fs_type: "",
    total: 0.0,
    free: 0.0,
    used: 0.0,
    used_percent: 0.0,
    inodes_total: 0.0,
    inodes_used: 0.0,
    inodes_free: 0.0,
    inodes_used_percent: 0.0
  ]
end
