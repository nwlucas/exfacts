defmodule ExFacts.System.Disk do
  alias ExFacts.System.Disk.{PartitionStat, IOCounterStat, UsageStat}
  import ExFacts.Utils
  require Logger

  @moduledoc """
  Handles all logic with regards to collecting metrics on the disks of the host.

  Direct calls can be made to all functions, but it recommended that only the
  following entry points be used.

  * `partitions/1`
  """
  @diskspath Application.get_env(:exfacts, :disks_path, "diskstats")
  @filesystems Application.get_env(:exfacts, :filesystems, "filesystems")
  @mtab Application.get_env(:exfacts, :mtab, "mtab")
  @stat_cmd Application.get_env(:exfacts, :stat_cmd, "stat")
  @udevpath Application.get_env(:exfacts, :udev_path, "/sbin/udevadm")

  # @sector_size 512
  @fs_type_map %{
    "0xADF5" => "ADFS",
    "0xADFF" => "AFFS",
    "0x5346414F" => "AFS",
    "0x09041934" => "ANON-INODE FS",
    "0x61756673" => "AUFS",
    "0x42465331" => "BEFS",
    "0x62646576" => "BDEVFS",
    "0x1BADFACE" => "BFS",
    "0x42494E4D" => "BINFMT_MISC",
    "0x9123683E" => "BTRFS",
    "0x00C36400" => "CEPH",
    "0x27E0EB" => "CGROUPFS",
    "0xFF534D42" => "CIFS",
    "0x73757245" => "CODA",
    "0x012FF7B7" => "COH",
    "0x28CD3D45" => "CRAMFS",
    "0x64626720" => "DEBUGFS",
    "0x1373" => "DEVFS",
    "0x1CD1" => "DEVPTS",
    "0xF15F" => "ERCYPTFS",
    "0xDE5E81E4" => "",
    "0x00414A53" => "EFS",
    "0x137D" => "EXT",
    "0xEF51" => "EXT2",
    "0xEF53" => "EXT2/EXT3",
    "0x4006" => "FAT",
    "0x19830326" => "FHGFS",
    "0x65735546" => "FUSEBLK",
    "0x65735543" => "FUSECTL",
    "0xBAD1DEA" => "FUSEXFS",
    "0x1161970" => "GFS/GFS2",
    "0x47504653" => "GPFS",
    "0x4244" => "HFS",
    "0x00C0FFEE" => "",
    "0xF995E849" => "HPFS",
    "0x958458F6" => "HUGETLBFS",
    "0x2BAD1DEA" => "INOTIFYFS",
    "0x9660" => "ISOFS",
    "0x4004" => "ISOFS",
    "0x4000" => "ISOFS",
    "0x07C0" => "JFFS",
    "0x72B6" => "JFFS2",
    "0x3153464A" => "JFS",
    "0x6B414653" => "K-AFS",
    "0x0BD00BD0" => "LUSTRE",
    "0x137F" => "MINIX",
    "0x138F" => "MINIX (30 CHAR)",
    "0x2468" => "MINIX V2",
    "0x2478" => "MINIX V2 (30 CHAR)",
    "0x4D5A" => "MINIX3",
    "0x19800202" => "MQUEUE",
    "0x4D44" => "MSDOS",
    "0x11307854" => "",
    "0x564C" => "NOVELL",
    "0x6969" => "NFS",
    "0x6E667364" => "NFSD",
    "0x3434" => "NILFS",
    "0x5346544E" => "NTFS",
    "0x7461636F" => "OCFS2",
    "0x9FA1" => "OPENPROM",
    "0xAAD7AAEA" => "PANFS",
    "0x50495045" => "PIPEFS",
    "0x9FA0" => "PROC",
    "0x6165676C" => "PSTOREFS",
    "0x002F" => "QNX4",
    "0x68191122" => "QNX6",
    "0x858458F6" => "RAMFS",
    "0x52654973" => "REISERFS",
    "0x7275" => "ROMFS",
    "0x67596969" => "RPC_PIPEFS",
    "0x73636673" => "SECURITYFS",
    "0xF97CFF8C" => "SELINUX",
    "0x43415D53" => "",
    "0x517B" => "SMB",
    "0x534F434B" => "SOCKFS",
    "0x73717368" => "SQUASHFS",
    "0x62656572" => "SYSFS",
    "0x012FF7B6" => "SYSV2",
    "0x012FF7B5" => "SYSV4",
    "0x01021994" => "TMPFS",
    "0x15013346" => "UDF",
    "0x54190100" => "UFS",
    "0x00011954" => "UFS",
    "0x9FA2" => "USBDEVFS",
    "0x01021997" => "V9FS",
    "0xBACBACBC" => "VMHGFS",
    "0xA501FCF5" => "VXFS",
    "0x565A4653" => "VZFS",
    "0xABBA1974" => "XENFS",
    "0x012FF7B4" => "XENIX",
    "0x58465342" => "XFS",
    "0x012FD16D" => "XIA",
    "0x2FC12FC1" => "ZFS"
  }

  @doc """
  Reads the disk information from the host, cleans up the data a bit and
  returns a list with the info.

  ## Options
    The accepted options are:
    * `:all` - configures which disks are returned, `true` for all, `false`
    for physical disks and their respective mounts only.
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

  @doc """
  Reads the hosts mtab and returns a list of lists containing the data for further use.
  """
  @spec read_mtab :: [[binary]]
  def read_mtab do
    filename = host_etc(@mtab)
    lines =
      filename
        |> read_file
        |> String.split("\n")
        |> Enum.map(& String.split(&1))
        |> Enum.map(& Enum.take(&1, 4))
        |> Enum.filter(& !Enum.empty?(&1))
    lines
  end

  @doc """
  Using the mtab information provided by `ExFacts.System.Disk.read_mtab/0` and the
  boolean variable _*all*_ it will return the filesystems of the host as list.
  """
  @spec get_file_systems(mtab :: [], all :: boolean) :: [binary]
  def get_file_systems(mtab, all) do
    filename = host_proc(@filesystems)
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

  @doc """
  Using the data provided by `ExFacts.System.Disk.get_file_systems/2` it
  converts each list item to populate a complete `ExFacts.System.Disk.PartitionStat`
  struct.
  """
  @spec generate_list(data :: []) :: %ExFacts.System.Disk.PartitionStat{}
  def generate_list(data) do
    %PartitionStat{
      device: Enum.fetch!(data, 0),
      mount_point: Enum.fetch!(data, 1),
      fs_type: Enum.fetch!(data, 2),
      opts: Enum.fetch!(data, 3)
    }
  end

  @doc """
  Queries the host udev subsystem to gather the data of a disk and returns the serial.
  Assumes the program will have access to udevadm either at the default path of
  /sbin/udevadm or the supplied path via configuration.
  """
  @spec get_serial(String.t) :: String.t
  def get_serial(disk) do
    n = "--name=" <> disk

    out =
      case look_path(@udevpath) do
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

  @doc """
  Returns `ExFacts.System.Disk.IOCounterStat` structs for each disk passed in.
  queries the host system to gather the IO data and populates the struct accordingly.
  """
  @spec io_counters([String.t]) :: [%ExFacts.System.Disk.IOCounterStat{}]
  def io_counters(disks) do
    filename = host_proc(@diskspath)
    content = read_file(filename)

    io_data =
      content
      |> String.split("\n")
      |> delete_all("")
      |> Enum.map(& String.split(&1))

    io_return =
      disks
      |> Enum.reduce([], & populate_io(&1, &2, io_data))
      |> List.flatten

    io_return
  end

  @doc """
  Auxilary function used by `ExFacts.System.Disk.io_counters/1` to create the struct with
  the passed in data for each disk.
  """
  @spec populate_io(String.t, List.t, [[String.t]]) :: [%ExFacts.System.Disk.IOCounterStat{}]
  def populate_io(name, acc, data) do
    ioc =
      data
      |> Enum.filter(& Enum.member?(&1, name))
      |> List.flatten
      |> Enum.map(& parse_float(&1))

    case ioc do
      [] -> acc
      _ ->
        iostat =
          [%IOCounterStat{
            read_count: Enum.fetch!(ioc, 3),
            merged_read_count: Enum.fetch!(ioc, 4),
            write_count: Enum.fetch!(ioc, 7),
            merged_write_count: Enum.fetch!(ioc, 8),
            read_bytes: Enum.fetch!(ioc, 5),
            write_bytes: Enum.fetch!(ioc, 9),
            read_time: Enum.fetch!(ioc, 6),
            write_time: Enum.fetch!(ioc, 10),
            iops_in_progress: Enum.fetch!(ioc, 11),
            io_time: Enum.fetch!(ioc, 12),
            weighted_io: Enum.fetch!(ioc, 13),
            name: name,
            serial_number: get_serial(name)
          }]

        [acc | iostat]
    end
  end

  @doc """
  Returns `ExFacts.System.Disk.UsageStat` struc for the passed in path.
  """
  @spec usage(String.t) :: %ExFacts.System.Disk.UsageStat{}
  def usage(path) do
    case look_path path do
      {:ok, p} ->
        out = System.cmd @stat_cmd, ["-f", p]
        case out do
          {output, 0} ->
            data =
              output
              |> String.split("\n", trim: true)
              |> Enum.map(& String.trim_leading(&1))
              |> Enum.map(& String.trim_trailing(&1))
              |> Enum.map(& String.split(&1, ~r/([\s]{1,})/, trim: true))
              |> List.flatten

            b_size = data |> Enum.fetch!(14) |> String.to_integer
            b_total = data |> Enum.fetch!(17) |> String.to_integer |> (&(&1 * b_size)).()
            b_free = data |> Enum.fetch!(19) |> String.to_integer |> (&(&1 * b_size)).()
            b_avail = data |> Enum.fetch!(21) |> String.to_integer |> (&(&1 * b_size)).()
            i_total = data |> Enum.fetch!(24) |> String.to_integer
            i_free = data |> Enum.fetch!(26) |> String.to_integer

            i_used = (i_total - i_free)
            b_used = b_total - b_free

            %UsageStat{
              path: path,
              fs_type: get_fs_type(path),
              total: b_total,
              free: b_avail,
              used: b_used,
              used_percent: (b_used / b_total) * 100.0,
              inodes_total: i_total,
              inodes_used: (i_total - i_free),
              inodes_free: i_free,
              inodes_used_percent: (i_used / i_total) * 100.0
            }

          {_, _} -> %UsageStat{}
        end
      {:error, reason} ->
        raise "#{__MODULE__}: #{reason}"
        %UsageStat{}
      _ ->
        raise "#{__MODULE__} error occured while attempting to gather information."
        %UsageStat{}
    end
  end

  @spec get_fs_type(String.t) :: String.t
  def get_fs_type(path) do
    {out, 0} = System.cmd @stat_cmd, ["-f", "--printf", "%t", path]

    c_out =
      case String.starts_with?(out, "0x") do
        false -> "0x" <> String.upcase(out)
        true -> String.upcase out
      end
    if Map.has_key?(@fs_type_map, c_out), do: Map.get(@fs_type_map, c_out), else: ""
  end
end
