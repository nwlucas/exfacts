defmodule ExFacts.System.Net.ConnectionStat do
  require ExFacts.System.Net.Addr
  @moduledoc """
  Holds connection data for the interfaces.

  ## Examples

      iex> io = %ExFacts.System.Net.ConnectionStat{status: "connected", pid: 33768}
      ...> io.pid
      33768
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    fd: integer,
    family: integer,
    status: binary,
    type: integer,
    l_addr: %ExFacts.System.Net.Addr{},
    r_addr: %ExFacts.System.Net.Addr{},
    u_ids: [integer],
    pid: integer
  }

  defstruct [
    fd: 0,
    family: 0,
    status: "",
    type: 0,
    l_addr: %ExFacts.System.Net.Addr{},
    r_addr: %ExFacts.System.Net.Addr{},
    u_ids: [0],
    pid: 0
  ]
end
