defmodule ExFacts.Host.InfoStat do
  @moduledoc """
    Provides a struct to hold Host data.

    ##Examples

      iex> h = %ExFacts.Host.InfoStat{hostname: "somehost", os: "Linux"}
      ...> h.os
      "Linux"
  """
  @derive [Poison.Encoder]

  @type t :: %ExFacts.Host.InfoStat{
    hostname: binary,
    uptime: integer,
    bootime: integer,
    procs: integer,
    os: binary,
    platform: binary,
    platform_family: binary,
    platform_version: binary,
    kernel_version: binary,
    virtualization_system: binary,
    virtualization_role: binary,
    host_id: binary
  }

  defstruct [
    hostname: "",
    uptime: 0,
    bootime: 0,
    procs: 0,
    os: "",
    platform: "",
    platform_family: "",
    platform_version: "",
    kernel_version: "",
    virtualization_system: "",
    virtualization_role: "",
    host_id: ""
  ]
end
