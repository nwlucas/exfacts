defmodule ExFacts.System.Net do
  alias ExFacts.System.Net.InterfaceStat
  import ExFacts.Utils

  @moduledoc """
  Handles all logic with regards to collecting metrics on the interfaces of the host.

  Direct calls can be made to every function in this module but that is strongly
  discouraged. As the surface area of the API grows it suggested that only the
  `interfaces/0` function is used as the entry point.

  `interfaces/0` returns a `ExFacts.System.CPU.InterfaceStat` populated struct.
  """

  @doc """
  Returns structs with data on the interfaces of the host. It serves as the main entry
  point to the `ExFacts.System.net` module.
  """

  @proto_map %{"TCP" => 0x1, "UDP" => 0x2, "IPv4" => 0x2, "IPv6" => 0xa}

  def interfaces do
    path = host_sys("/class/net")

    is =
      path
      |> File.ls!
      |> Enum.map(fn x -> %InterfaceStat
        {
          name: x,
          hardware_addr: read_file(path <> "/#{x}/address") |> String.trim("\n"),
          mtu: read_file(path <> "/#{x}/mtu") |> String.trim("\n") |> String.to_integer
        } end)
  end
end
