defmodule ExFacts.Mem.SwapMemStat do
  @moduledoc """
    Provides a struct to hold virtual memory data.

    ##Examples

    iex> sm = %ExFacts.Mem.SwapMemStat{total: 320000, used: 6000, free: 26000}
    ...> sm.free
    26000
  """
  @derive [Poison.Encoder]

  @type t :: %ExFacts.Mem.SwapMemStat {
    total: integer,
    used: integer,
    used_percent: float,
    free: integer,
    sin: integer,
    sout: integer
  }

  defstruct [
    total: 0,
    used: 0,
    used_percent: 0.0,
    free: 0,
    sin: 0,
    sout: 0
  ]
end
