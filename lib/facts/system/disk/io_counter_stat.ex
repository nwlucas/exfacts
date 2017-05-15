defmodule ExFacts.System.Disk.IOCounterStat do
  @moduledoc """
    Provides a struct to hold IO counters data.

    ## Examples

        iex> i = %IOCounterStat{name: "somedrive", read_count: "14"}
        ...> i.name
        "somedrive"
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    read_count: float,
    merged_read_count: float,
    write_count: float,
    merged_write_count: float,
    read_bytes: float,
    write_bytes: float,
    read_time: float,
    write_time: float,
    iops_in_progress: float,
    io_time: float,
    weighted_io: float,
    name: binary,
    serial_number: binary,
  }

  defstruct [
    read_count: 0.0,
    merged_read_count: 0.0,
    write_count: 0.0,
    merged_write_count: 0.0,
    read_bytes: 0.0,
    write_bytes: 0.0,
    read_time: 0.0,
    write_time: 0.0,
    iops_in_progress: 0.0,
    io_time: 0.0,
    weighted_io: 0.0,
    name: "",
    serial_number: "",
  ]
end
