defmodule ExFacts.System.Net.InterfaceAddr do
  @moduledoc """
  Holds IP address(es) for an interface.

  ## Examples

      iex> addr = %ExFacts.System.Net.InterfaceAddr{addr: "192.168.1.50"}
      ...> addr.addr
      "192.168.1.50"
  """
  @derive [Poison.Encoder]

  @type t :: %__MODULE__{
    addr: binary
  }

  defstruct [
    addr: ""
  ]
end
