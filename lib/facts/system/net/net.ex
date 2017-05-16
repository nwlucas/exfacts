defmodule ExFacts.System.Net do
  alias ExFacts.System.Net.InterfaceStat
  import ExFacts.Utils
  use Bitwise

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
          hardware_addr: read_file(path <> "/#{x}/address") |> String.strip(),
          mtu: read_file(path <> "/#{x}/mtu") |> String.strip |> String.to_integer(),
          flags: get_sys_flags(x)
        } end)

    is
  end

  @spec get_sys_flags(binary) :: [binary]
  defp get_sys_flags(interface) do
    path = host_sys("/class/net/" <> interface)

    iff_flags = File.read!(path <> "/flags")
                |> String.strip
                |> String.trim_leading("0x")
                |> String.to_integer(16)

    flags = if (iff_flags &&& 1) != 0, do: ["UP"]
    flags = if (iff_flags &&& 2) != 0, do: flags ++ ["BROADCAST"], else: flags ++ []
    flags = if (iff_flags &&& 3) != 0, do: flags ++ ["LOOPBACK"], else: flags ++ []
    flags = if (iff_flags &&& 4) != 0, do: flags ++ ["POINTTOPOINT"], else: flags ++ []
    flags = if (iff_flags &&& 5) != 0, do: flags ++ ["MULTICAST"], else: flags ++ []

    flags
  end
end
