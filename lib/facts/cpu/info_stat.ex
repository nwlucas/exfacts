defmodule Facts.CPU.InfoStat do
  @moduledoc """
    Provides a struct to hold CPU data.

    ##Examples

      iex> d = %InfoStat{cpu: 0, model_name: "AuthenticAMD"}
      ...> d.model_name
      "AuthenticAMD"
  """
  @derive [Poison.Encoder]

  @type t :: %Facts.CPU.InfoStat{
    cpu: integer,
    vendor_id: binary,
    family: binary,
    model: binary,
    stepping: integer,
    physical_id: binary,
    core_id: binary,
    cores: integer,
    model_name: binary,
    mhz: float,
    cache_size: integer,
    flags: list,
    microcode: binary
    }

  defstruct [
    cpu: 0,
    vendor_id: "",
    family: "",
    model: "",
    stepping: 0,
    physical_id: "",
    core_id: "",
    cores: 0,
    model_name: "",
    mhz: 0.0,
    cache_size: 0,
    flags: [],
    microcode: ""
  ]
end
