defmodule ExFacts.System.Net.InterfaceStat do
  require ExFacts.System.Net.InterfaceAddr
  @moduledoc """
  Holds data for the interfaces.

  ## Examples

      iex> interface = %ExFacts.System.Net.InterfaceStat{name: "en0", mtu: 1500}
      ...> interface.name
      "en0"
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    mtu: integer,
    name: binary,
    hardware_addr: binary,
    addrs: [%ExFacts.System.Net.InterfaceAddr{}],
    flags: [binary]
  }

  defstruct [
    mtu: 0,
    name: "",
    hardware_addr: "",
    addrs: [%ExFacts.System.Net.InterfaceAddr{}],
    flags: [""]
  ]
end
