defmodule ExFacts.System.CPU do
  alias ExFacts.System.CPU.InfoStat
  import ExFacts.Utils
  require Logger

  @moduledoc """
  Handles all logic with regards to collecting metrics on the CPUs of the host.

  Direct calls can be made to every function in this module but that is strongly
  discouraged. As the surface area of the API grows it suggested that only the
  `cpu_info/0` function is used as the entry point.

  `cpu_info/0` returns a `ExFacts.System.CPU.InfoStat` populated struct.
  """
  @cpuinfo Application.get_env(:exfacts, :cpuinfo, "cpuinfo")
  @nproc Application.get_env(:exfacts, :nproc, "nproc")

  @doc """
  Returns the integer number of processors that on the host.
  Currently it relies on a call to the the system utility nproc, which means
  this function will only on Unix or Unix like systems.
  """
  @spec counts :: integer
  def counts do
   case System.cmd @nproc, [] do
     {k, 0} ->
       k
       |> String.replace("\n", "")
       |> String.to_integer
     {_, _} -> raise "Unable to determine the CPU count"
   end
  end

  @doc """
  Returns a properly formed struct containing data on the host systems cpu(s).
  """
  @spec cpu_info :: {atom, [%InfoStat{}]} | binary
  def cpu_info do
    filename = host_proc(@cpuinfo)

    info =
      filename
        |> read_file()
        |> parse_info()

    File.close filename

    info =
      cond do
        is_nil(info) -> %InfoStat{}
        "" == info -> %InfoStat{}
        true -> info
      end

    {:ok, info}
  end

  def parse_info({:error, reason}), do: raise "#{__MODULE__} error #{inspect reason}"
  def parse_info(in_data) when is_binary(in_data) do
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
  end

  @spec finish_info(map) :: map
  def finish_info(data) when is_map(data) do
    for {key, val} <- data, into: %{} do
      {String.to_atom(String.trim_leading(key, "cpu_")),  String.trim(val)}
    end
  end

  @spec flatten_info(list, map) :: map
  def flatten_info(list, m \\ %{})
  def flatten_info([], m), do: m
  def flatten_info(list, m), do: flatten_info(tl(list), Map.merge(m, hd(list)))

  @spec split_data(original :: [String.t]) :: []
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

  @spec populate_info(map) :: %ExFacts.System.CPU.InfoStat{}
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
