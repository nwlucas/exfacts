defmodule ExFacts.System.Net do
  alias ExFacts.System.Net.InterfaceStat
  alias ExFacts.System.Net.InterfaceAddr
  import ExFacts.Utils
  @moduledoc """
  Handles all logic with regards to collecting metrics on the interfaces of the host.

  Direct calls can be made to every function in this module but that is strongly
  discouraged. As the surface area of the API grows it suggested that only the
  `interfaces/0` function is used as the entry point.

  `interfaces/0` returns a `ExFacts.System.CPU.InterfaceStat` populated struct.
  """

  @proto_map %{"TCP" => 0x1, "UDP" => 0x2, "IPv4" => 0x2, "IPv6" => 0xa}

  @doc """
  Returns structs with data on the interfaces of the host. It serves as the main entry
  point to the `ExFacts.System.net` module.

  Mainly a wapper around Erlang `:inet.getifaddrs()`
  """
  @spec interfaces :: [%ExFacts.System.Net.InterfaceStat{}]
  def interfaces do
    {:ok, ifis} = :inet.getifaddrs()
    ifs = ifis |> Enum.map(&parse_ifis/1)
    ifs
  end

  @spec parse_ifis(tuple) :: %ExFacts.System.Net.InterfaceStat{}
  defp parse_ifis(ifi) do
    {int_name, int_options} = ifi

    flags =
      int_options[:flags]
      |> Enum.map(&Atom.to_string/1)

    hwaddr =
      int_options[:hwaddr]
      |> Enum.map(& Integer.to_string(&1, 16))
      |> Enum.map(fn x -> if String.length(x) <= 1, do: String.pad_leading(x, 2, "0"), else: x end)
      |> Enum.reduce(fn left, right -> right <> ":" <> left end)

    addrs =
      int_options
      |> Keyword.take([:addr, :netmask, :broadaddr, :destaddr])
      |> sift_addrs()

    filename = host_sys("/class/net")
    contents = File.read!(filename <> "/#{int_name}/mtu")

    mtu = contents |> String.strip |> String.to_integer

    %InterfaceStat{
      name: to_string(int_name),
      hardware_addr: hwaddr,
      flags: flags,
      addrs: addrs,
      mtu: mtu
    }
  end

  @spec sift_addrs(list :: List.t, acc :: List.t) :: [%ExFacts.System.Net.InterfaceAddr{}] | []
  defp sift_addrs(list, acc \\ [])
  defp sift_addrs([{:addr, addr} | tail], acc) do
    {baddr, tail} = if Keyword.has_key?(tail, :broadaddr), do: Keyword.pop_first(tail, :broadaddr), else: {nil, tail}
    {nmask, tail} = if Keyword.has_key?(tail, :netmask), do: Keyword.pop_first(tail, :netmask), else: {nil, tail}
    {daddr, tail} = if Keyword.has_key?(tail, :destaddr), do: Keyword.pop_first(tail, :destaddr), else: {nil, tail}

    int_addr = %InterfaceAddr{
                  address: parse_addr(addr),
                  broadcast: parse_addr(baddr),
                  netmask: parse_addr(nmask),
                  destination: parse_addr(daddr)} |> List.wrap

    sift_addrs(tail, acc ++ int_addr)
  end
  defp sift_addrs([], acc), do: acc

  @spec parse_addr(Tuple.t) :: String.t
  defp parse_addr(addr) when tuple_size(addr) == 4 do
    addr
    |> Tuple.to_list
    |> Enum.reduce("", fn x, acc -> acc <> to_string(x) <> "." end)
    |> String.trim_trailing(".")
  end
  defp parse_addr(addr) when tuple_size(addr) == 8 do
    addr
    |> Tuple.to_list
    |> Enum.map(& Integer.to_string(&1, 16))
    |> Enum.reduce("", fn x, acc -> acc <> x <> "::" end)
    |> String.trim_trailing("::")
    |> String.downcase
  end
  defp parse_addr(nil), do: ""
end
