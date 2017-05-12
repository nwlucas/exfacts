defmodule ExFacts do
  @moduledoc """
  Provides the entry point for the facts gathering and output.

  The module has facilities that can collect and parse system metrics or facts
  for a variety of different key system areas. Currently on Linux systems are
  implemented but ultimately the tool should allow the same functionality across
  many diffrent operating systems

  ## CPU

  ## Disk

  ## Host

  ## Load

  ## Mem

  ## Net
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
