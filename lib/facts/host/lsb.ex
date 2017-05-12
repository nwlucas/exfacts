defmodule ExFacts.Host.LSB do
  @moduledoc """
    Provides a struct to hold Host data.

    ##Examples

      iex> h = %ExFacts.Host.LSB{hostname: "somehost", os: "Linux"}
      ...> h.os
      "Linux"
  """
  @derive [Poison.Encoder]

  @type t :: %ExFacts.Host.LSB{
    id: binary,
    release: binary,
    codename: binary,
    description: binary
  }

  defstruct [
    id: "",
    release: "",
    codename: "",
    description: ""
  ]
end
