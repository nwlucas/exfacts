defmodule ExFacts do
  @moduledoc """
  Provides the entry point for the facts gathering and output.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      alias ExFacts.CPU, as: ExCPU
      alias ExFacts.Disk, as: ExDisk
      alias ExFacts.Host, as: ExHost
      alias ExFacts.Load, as: ExLoad
      alias ExFacts.Mem, as: ExMem
      alias ExFacts.Net, as: ExNet

      import ExFacts.Gather
    end
  end
end
