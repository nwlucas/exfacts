defmodule ExFacts.Load.MiscStat do
  @moduledoc """
    Provides a struct to hold miscellaneous data.

    ##Examples

      iex> m = %ExFacts.Load.MiscStat{procs_running: 192, procs_blocked: 5, ctxt: 242}
      ...> m.procs_blocked
      5
  """
  @derive [Poison.Encoder]

  @type t :: %ExFacts.Load.MiscStat {
    procs_running: integer,
    procs_blocked: integer,
    ctxt: integer
  }

  defstruct [
    procs_running: 0,
    procs_blocked: 0,
    ctxt: 0
  ]
end
