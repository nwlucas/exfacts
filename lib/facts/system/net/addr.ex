defmodule ExFacts.System.Net.Addr do
  @moduledoc """
  Holds IP address data for the interfaces.

  ## Examples

      iex> addr = %ExFacts.System.Net.Addr{ip: "192.168.1.50", port: 4357}
      ...> addr.port
      4357
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    ip: binary,
    port: integer
  }

  defstruct [
    ip: "",
    port: 0,
  ]
end
