defmodule ExFacts.System.Net.FilterStat do
  @moduledoc """
  Holds data for the connection tracking.

  ## Examples

      iex> filter = %ExFacts.System.Net.FilterStat{conn_track_count: 123456}
      ...> filter.conn_track_count
      123456
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    conn_track_count: integer,
    conn_track_max: integer
  }

  defstruct [
    conn_track_count: 0,
    conn_track_max: 0
  ]
end
