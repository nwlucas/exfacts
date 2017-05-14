defmodule ExFacts.System.Disk do
  @moduledoc """
  """
  alias ExFacts.System.Disk.PartitionStat
  import ExFacts.Utils
  require ExFacts.System.Disk.Constants
  require Logger

  @doc """
  `ExFacts.System.Disk.partitions/1` reads the disk information from the host,
  cleans up the data a bit and returns a list with the info. Depending on the
  value of all it will return all disks if true, or only physical disks if false.
  """
  @spec partitions(boolean) :: tuple
  def partitions(all \\ true) do
    p = read_mtab()
      |> get_file_systems(all)
      |> Enum.map(& generate_list(&1))

    {:ok, p}
  rescue
    e -> Logger.error "Error occured while attempting to gather partitions facts: " <> e
    {:error, e}
  end

  @spec read_mtab :: [[binary]]
  def read_mtab do
    filename = host_etc("mtab")
    lines =
      filename
        |> read_file
        |> String.split("\n")
        |> Enum.map(& String.split(&1))
        |> Enum.map(& Enum.take(&1, 4))
        |> Enum.filter(& !Enum.empty?(&1))
    lines
  end

  @spec get_file_systems(mtab :: [], all :: boolean) :: [binary]
  def get_file_systems(mtab, all) do
    filename = host_proc("filesystems")
    fs =
      filename
        |> read_file
        |> String.split("\n")
        |> Enum.filter(& !(String.length(&1) == 0))
        |> Enum.reject(& String.starts_with?(&1, "nodev"))
        |> Enum.map(& String.trim_leading(&1, "\t"))

    data =
      case all do
        false -> Enum.filter(mtab, & Enum.member?(fs, Enum.fetch!(&1, 2)))
        _ -> mtab
      end

    data
  end

  @spec generate_list(data :: []) :: %ExFacts.System.Disk.PartitionStat{}
  def generate_list(data) do
    %PartitionStat{
      device: Enum.fetch!(data, 0),
      mount_point: Enum.fetch!(data, 1),
      fs_type: Enum.fetch!(data, 2),
      opts: Enum.fetch!(data, 3)
    }
  end

  @spec get_serial_number(String.t) :: String.t
  def get_serial_number(disk) do
    n = "--name=" <> disk

    out =
      case look_path("/sbin/udevadm") do
        {:ok, udevadm} -> System.cmd udevadm, ["info", "--query=property", n]
        {:error, reason} -> {:error, reason}
      end

    case out do
      {output, 0} ->
        lines =
          output
          |> String.split("\n")
          |> delete_all("")
          |> Enum.map(& String.split(&1, "="))
          |> Enum.flat_map(fn [k, v] -> Map.put(%{}, k, v) end)
          |> Enum.into(%{})

        if Map.has_key?(lines, "ID_SERIAL"), do: Map.fetch!(lines, "ID_SERIAL"), else: ""
      {:error, _reason} -> ""
      {_, _} ->
        raise "#{__MODULE__} error from udevadm."
        ""
    end
  end
end
