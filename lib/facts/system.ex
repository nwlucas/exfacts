defmodule ExFacts.System do
  alias ExFacts.System.{CPU, Disk, Host, Load, Mem, Net}
  @moduledoc """
  Provides a common entry point to gather all internal information in one command and returns a serialized JSON reponse.
  """

  @doc """
  Returns the facts of the system in JSON format.

  It calls all underlying modules and aggregates the returned data then formats it in the desired JSON output.
  """
  @type t :: binary

  @spec gather_system(Keyword.t) :: t
  def gather_system(opts \\ []) do
    defaults = [partitions: true, cpus: true]
    options = Keyword.merge(defaults, opts)

    {:ok, c} = CPU.cpu_info()
    {:ok, h} = Host.host_info()
    {:ok, d} = Disk.partitions(options[:partitions])
    {:ok, load_avg} = Load.avg()
    {:ok, load_misc} = Load.misc()
    {:ok, %{virtual: vm, swap: sm}} = Mem.memory_info()

    data =
      %{data:
        %{
          processors: transform_cpu(c),
          host: h,
          memory: %{
            swap: sm,
            virtual: vm
          },
          disks: d,
          load: %{
            average: load_avg,
            misc: load_misc
          }
        }
      }

    Poison.encode! data, strict_keys: true
  end

  @spec transform_cpu([%CPU.InfoStat{}]) :: Map.t
  defp transform_cpu(data) do
    data |> Enum.with_index() |> Enum.flat_map(fn {v, k} -> %{"cpu#{k}": v} end) |> Enum.into(%{})
  end
end
