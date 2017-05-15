defmodule ExFacts.System.Mem.VirtualMemStat do
  @moduledoc """
    Provides a struct to hold virtual memory data.

    ## Examples

      iex> vm = %ExFacts.System.Mem.VirtualMemStat{total: 320000, buffers: 15000, dirty: 2000}
      ...> vm.buffers
      15000
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    total: integer,
    available: integer,
    used: integer,
    used_percent: float,
    free: integer,

    # OSX/BSD specific numbers
    active: integer,
    inactive: integer,
    wired: integer,

    #Linux specific numbers
    buffers: integer,
    cached: integer,
    writeback: integer,
    dirty: integer,
    writeback_tmp: integer,
    shared: integer,
    slab: integer,
    page_tables: integer,
    swap_cached: integer
  }

  defstruct [
    total: 0,
    available: 0,
    used: 0,
    used_percent: 0.0,
    free: 0,
    active: 0,
    inactive: 0,
    wired: 0,
    buffers: 0,
    cached: 0,
    writeback: 0,
    dirty: 0,
    writeback_tmp: 0,
    shared: 0,
    slab: 0,
    page_tables: 0,
    swap_cached: 0
  ]
end
