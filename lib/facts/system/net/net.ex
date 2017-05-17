defmodule ExFacts.System.Net do
  alias ExFacts.System.Net.InterfaceStat
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
      |> Enum.reduce_while([], &addrs_sifter/2)

    %InterfaceStat{
      name: to_string(int_name),
      hardware_addr: hwaddr,
      flags: flags
    }
  end

  defp addrs_sifter(orig, acc) do
    {a, iter} = if Keyword.has_key?(orig, :addr), do: Keyword.pop_first(orig, :addr)
    {n, iter} = if Keyword.has_key?(orig, :netmask), do: Keyword.pop_first(orig, :netmask)
    {b, iter} = if Keyword.has_key?(orig, :broadcast), do: Keyword.pop_first(orig, :broadcast)
  end
end
