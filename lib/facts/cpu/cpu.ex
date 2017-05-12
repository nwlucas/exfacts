defmodule ExFacts.CPU do
  @moduledoc """
  Handles all logic with regards to collecting metrics on the CPUs of the host. Returns a `ExFactsCPU.InfoStat` populated struct.
  """
  alias ExFacts.CPU.{InfoStat, TimeStat}
  import ExFacts.Utils
  require Logger

  @doc """
  Returns the integer number of processors that on the host.
  Currently it relies on a call to the the system utility nproc, which means
  this function will only on Unix or Unix like systems.
  """
  @spec counts :: integer
  def counts do
   case System.cmd "nproc", [] do
     {k, 0} ->
        String.to_integer(String.replace(k, "\n", ""))
     {_, _} -> raise "Unable to determine the CPU count"
   end
  end

  @spec cpu_info :: %InfoStat{} | binary
  def cpu_info do
    filename = host_proc("cpuinfo")

    info =
      filename
        |> File.read()
        |> parse_info()

    File.close filename
    cond do
      is_nil(info) -> %InfoStat{}
      "" == info -> %InfoStat{}
      true -> info
    end
  end

  def parse_info({:error, _reason}), do: Logger.error "Unable to read CPU Info because we are unable to read the file."
  def parse_info({:ok, in_data}) when is_binary(in_data) do
    data =
      in_data
       |> String.split("\n")
       |> Enum.map(& sanitize_data(&1))
       |> Enum.map(& normalize_with_underscore(&1))
       |> Enum.map(& finish_info(&1))
       |> delete_all(%{})
       |> split_data()
       |> Enum.map(& flatten_info(&1))
       |> Enum.map(& populate_info(&1))

    data
  rescue
      e ->  Logger.error "Error occured while attempting to parse CPU infomation. Error: " <> e
      %InfoStat{}
  end

  @spec split_data(original :: list) :: list
  def split_data(data) do
    i =
      data
        |> Enum.with_index
        |> Enum.filter_map(fn {m, _} -> Map.has_key?(m, :processor) end , fn {_, i} -> i end)

    interval = hd(tl(i)) - hd(i)
    split_data(data, interval)
  end

  @spec split_data(original :: list, interval :: integer) :: list
  def split_data(data, i) do
    Enum.chunk(data, i)
  end

  @spec flatten_info(list, map) :: map
  def flatten_info(list, m \\ %{})
  def flatten_info([], m), do: m
  def flatten_info(list, m), do: flatten_info(tl(list), Map.merge(m, hd(list)))

  @spec finish_info(map) :: map
  def finish_info(data) when is_map(data) do
    for {key, val} <- data, into: %{} do
      {String.to_atom(String.trim_leading(key, "cpu_")),  String.trim(val)}
    end
  end

  @spec populate_info(map) :: %ExFacts.CPU.InfoStat{}
  def populate_info(data) when is_map(data) do
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
end
