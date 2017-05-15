defmodule ExFacts.System.Net.IOCounterStat do
  @moduledoc """
  Holds performance data for the interfaces.

  ## Examples

      iex> io = %ExFacts.System.Net.IOCounterStat{name: "eth0", err_in: 0}
      ...> io.name
      "eth0"
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    name: binary,
    bytes_sent: integer,
    bytes_recv: integer,
    packets_sent: integer,
    packets_recv: integer,
    err_in: integer,
    err_out: integer,
    drop_in: integer,
    drop_out: integer,
    fifo_in: integer,
    fifo_out: integer
  }

  defstruct [
    name: "",
    bytes_sent: 0,
    bytes_recv: 0,
    packets_sent: 0,
    packets_recv: 0,
    err_in: 0,
    err_out: 0,
    drop_in: 0,
    drop_out: 0,
    fifo_in: 0,
    fifo_out: 0
  ]
end
