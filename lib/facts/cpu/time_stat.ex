defmodule Facts.CPU.TimesStat do
  @moduledoc """
    Provides a struct to hold CPU data.

    ##Examples

      iex> d = %TimeStat{cpu: 0, user: "SomeUser"}
      ...> d.user
      "SomeUser"
  """

  @derive [Poison.Encoder]

  defstruct [
    :cpu,
    :user,
    :system,
    :idle,
    :nice,
    :iowait,
    :irq,
    :softirq,
    :steal,
    :guest,
    :guest_nice,
    :stolen,
  ]
end
