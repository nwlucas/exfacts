defmodule ExFacts.System.Net.ProtocolCounterStat do
  @moduledoc """
  System wide stats about different network protocols.

  ## Examples

      iex> io = %ExFacts.System.Net.ProtocolCounterStat{protocol: "tcp"}
      ...> io.protocol
      "tcp"
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    protocol: binary,
    stats: %{binary => integer}
  }

  defstruct [
    protocol: "",
    stats: %{}
  ]
end
