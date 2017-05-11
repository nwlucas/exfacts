defmodule Facts.Load.AvgStat do
  @moduledoc """
    Provides a struct to hold average load data.

    ##Examples

      iex> a = %Facts.Load.AvgStat{load1: 1.5, load5: 0.98, load15: 2.42}
      ...> a.load15
      2.42
  """
  @derive [Poison.Encoder]

  @type t :: %Facts.Load.AvgStat {
    load1: float,
    load5: float,
    load15: float
  }

  defstruct [
    load1: 0.0,
    load5: 0.0,
    load15: 0.0
  ]
end
