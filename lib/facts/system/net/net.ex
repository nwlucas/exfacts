defmodule ExFacts.System.Net do
  alias ExFacts.System.Net.{InterfaceStat, InterfaceAddr, IOCounterStat}
  import ExFacts.Utils
  @moduledoc """
  Handles all logic with regards to collecting metrics on the interfaces of the host.

  Direct calls can be made to every function in this module but that is strongly
  discouraged. As the surface area of the API grows it suggested that only the
  `interfaces/0` function is used as the entry point.

  `interfaces/0` returns a list of `ExFacts.System.CPU.InterfaceStat` populated structs.
  `io-counters/1` returns different structures depending on the value of argument passed in.
  """

  @proto_map %{"TCP" => 0x1, "UDP" => 0x2, "IPv4" => 0x2, "IPv6" => 0xa}

  @doc """
  Returns structs with data on the interfaces of the host. It serves as the main entry
  point to the `ExFacts.System.net` module.

  Mainly a wapper around Erlang `:inet.getifaddrs()`
  """
  @spec interfaces :: [%__MODULE__.InterfaceStat{}]
  def interfaces do
    {:ok, ifis} = :inet.getifaddrs()
    ifs = ifis |> Enum.map(&parse_ifis/1)
    ifs
  end

  def io_counters(pernic \\ false) do
    filename = host_proc("net/dev")
    content = read_file(filename, sane: true)

    ifs =
      content
      |> Enum.drop(2)
      |> Enum.map(fn x -> x |> String.split(":") |> Enum.map(& String.strip(&1)) |> List.to_tuple end)

    ifs_stats = ifs |> Enum.reduce([], &parse_io_counters/2)
    if pernic, do: ifs_stats , else: get_io_counters_all(ifs_stats)
  end

  @spec get_io_counters_all([%__MODULE__.IOCounterStat{}]) :: %__MODULE__.IOCounterStat{}
  defp get_io_counters_all(ifs) do

    all = %IOCounterStat{name: "all"}

    tally =
      ifs |> Enum.reduce(all, fn x, acc ->
          {_, acc} = get_and_update_in(acc.bytes_sent, fn v -> {v, v + x.bytes_sent} end)
          {_, acc} = get_and_update_in(acc.bytes_recv, fn v -> {v, v + x.bytes_recv} end)
          {_, acc} = get_and_update_in(acc.packets_sent, fn v -> {v, v + x.packets_sent} end)
          {_, acc} = get_and_update_in(acc.packets_recv, fn v -> {v, v + x.packets_recv} end)
          {_, acc} = get_and_update_in(acc.err_in, fn v -> {v, v + x.err_in} end)
          {_, acc} = get_and_update_in(acc.err_out, fn v -> {v, v + x.err_out} end)
          {_, acc} = get_and_update_in(acc.drop_in, fn v -> {v, v + x.drop_in} end)
          {_, acc} = get_and_update_in(acc.drop_out, fn v -> {v, v + x.drop_out} end)
          {_, acc} = get_and_update_in(acc.fifo_in, fn v -> {v, v + x.fifo_in} end)
          {_, acc} = get_and_update_in(acc.fifo_out, fn v -> {v, v + x.fifo_out} end)

          acc
        end)

    tally
  end

  @spec parse_io_counters(Tuple.t, [] | [%__MODULE__.IOCounterStat{}]) :: [%__MODULE__.IOCounterStat{}]
  defp parse_io_counters(data, acc) do
    {if_name, if_stats} = data

    fields = if_stats |> String.split |> Enum.map(& String.to_integer(&1))
    nic = %IOCounterStat{
            name: if_name,
            bytes_sent: Enum.fetch!(fields, 8),
            bytes_recv: Enum.fetch!(fields, 0),
            packets_sent: Enum.fetch!(fields, 9),
            packets_recv: Enum.fetch!(fields, 1),
            err_in: Enum.fetch!(fields, 2),
            err_out: Enum.fetch!(fields, 10),
            drop_in: Enum.fetch!(fields, 3),
            drop_out: Enum.fetch!(fields, 11),
            fifo_in: Enum.fetch!(fields, 4),
            fifo_out: Enum.fetch!(fields, 12)
          }

    acc = acc ++ List.wrap(nic)
    acc
  end

  @doc false
  @spec parse_ifis(tuple) :: %__MODULE__.InterfaceStat{}
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

  @doc false
  @spec sift_addrs(list :: List.t, acc :: List.t) :: [%__MODULE__.InterfaceAddr{}] | []
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

  @doc false
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
