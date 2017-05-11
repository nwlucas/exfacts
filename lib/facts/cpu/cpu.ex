defmodule Facts.CPU do
  @moduledoc """

  `Facts.CPU` handles all logic with regards to collecting metrics on the CPUs of the host.

  """
  alias Facts.CPU.{InfoStat, TimeStat}
  import Facts.Utils
  require Logger

  @spec counts :: integer
  def counts do
   case System.cmd "nproc", [] do
     {k, 0} ->
        String.to_integer(String.replace(k, "\n", ""))
     {_, _} -> raise "Unable to determine the CPU count"
   end
  end

  @spec cpu_info :: tuple
  def cpu_info do
    filename = host_proc("cpuinfo")
    file = File.open!(filename)
    data =
      file
       |> IO.binstream(:line)
       |> Enum.map(& sanitize_data(&1))
       |> Enum.map(& normalize_with_underscore(&1))
       |> Enum.map(& finish_info(&1))
       |> delete_all(%{})
       |> split_data()
       |> Enum.map(& flatten_info(&1))
       |> Enum.map(& populate_info(&1))

    {:ok, data}
  end

  @spec split_data(original :: list) :: list
  defp split_data(data) do
    i =
      data
        |> Enum.with_index
        |> Enum.filter_map(fn {m, _} -> Map.has_key?(m, :processor) end , fn {_, i} -> i end)

    interval = hd(tl(i)) - hd(i)
    split_data(data, interval)
  end

  @spec split_data(original :: list, interval :: integer) :: list
  defp split_data(data, i) do
    Enum.chunk(data, i)
  end

  @spec flatten_info(list, map) :: map
  defp flatten_info(list, m \\ %{})
  defp flatten_info([], m), do: m
  defp flatten_info(list, m), do: flatten_info(tl(list), Map.merge(m, hd(list)))

  @spec finish_info(map) :: map
  defp finish_info(data) when is_map(data) do
    for {key, val} <- data, into: %{} do
      {String.to_atom(String.trim_leading(key, "cpu_")),  String.trim(val)}
    end
  end

  @spec populate_info(map) :: %Facts.CPU.InfoStat{}
  defp populate_info(data) when is_map(data) do
    cd =  for {key, val} <- data, into: %{} do
            case key do
              :processor -> {:cpu, String.to_integer(val)}
              :flags -> {key, String.split(val)}
              :cores -> {key, String.to_integer(val)}
              :stepping -> {key, String.to_integer(val)}
              :mhz -> {key, (String.to_float(val) / 1000)}
              :cache_size ->
                v = hd(String.split(val))
                {key, String.to_integer(v)}
              _ -> {key, val}
            end
          end
    struct(InfoStat, cd)
  end

#    defp populate_time(data) when is_list(data) do
#
#    end
end
