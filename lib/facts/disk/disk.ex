defmodule Facts.Disk do
  @moduledoc """
  """
  alias Facts.Disk.PartitionStat
  import Facts.Utils
  require Facts.Disk.Constants
  require Logger

  @doc """
  `Facts.Disk.partitions/1` reads the disk information from the host, cleans up the data a bit and returns a list
  with the info. Depending on the value of all it will return all disks if true, or only physical disks if false.
  """
  @spec partitions(boolean) :: tuple
  def partitions(all \\ true) do
    try do
      p = read_mtab()
        |> get_file_systems(all)
        |> Enum.map(& generate_list(&1))

      {:ok, p}
    rescue
      e -> Logger.error "Error occured while attempting to gather partitions facts: " <> e
      {:error, e}
    end
  end

  @spec read_mtab :: list(list(String.t))
  defp read_mtab do
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

  @spec get_file_systems(mtab :: list, all :: boolean) :: list(String.t)
  defp get_file_systems(mtab, all) do
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

  @spec generate_list(data :: list) :: %Facts.Disk.PartitionStat{}
  defp generate_list(data) do
    %PartitionStat{
      device: Enum.fetch!(data, 0),
      mount_point: Enum.fetch!(data, 1),
      fs_type: Enum.fetch!(data, 2),
      opts: Enum.fetch!(data, 3)
    }
  end
end
