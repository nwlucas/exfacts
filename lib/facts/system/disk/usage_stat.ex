defmodule ExFacts.System.Disk.UsageStat do
  @moduledoc """
    Provides a struct to hold usage data.

    ## Examples

        iex> u = %UsageStat{path: "/", used_persent: "14"}
        ...> u.path
        "/"
  """
  @derive [Poison.Encoder]

  @type t :: %ExFacts.System.Disk.UsageStat{
    path: binary,
    fs_type: binary,
    total: integer,
    free: integer,
    used: integer,
    used_percent: float,
    inodes_total: integer,
    inodes_used: integer,
    inodes_free: integer,
    inodes_used_percent: float
  }

  defstruct [
    path: "",
    fs_type: "",
    total: 0,
    free: 0,
    used: 0,
    used_percent: 0.0,
    inodes_total: 0,
    inodes_used: 0,
    inodes_free: 0,
    inodes_used_percent: 0.0
  ]
end
