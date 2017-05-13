defmodule ExFacts do
  @moduledoc """
  Provides the entry point for the facts gathering and output.

  The module has facilities that can collect and parse system metrics or facts
  for a variety of different key system areas. Currently on Linux systems are
  implemented but ultimately the tool should allow the same functionality across
  many diffrent operating systems

  ## System.CPU

  ## System.Disk

  ## System.Host

  ## System.Load

  ## System.Mem

  ## System.Net
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      alias ExFacts.System.CPU, as: ExCPU
      alias ExFacts.System.Disk, as: ExDisk
      alias ExFacts.System.Host, as: ExHost
      alias ExFacts.System.Load, as: ExLoad
      alias ExFacts.System.Mem, as: ExMem
      alias ExFacts.System.Net, as: ExNet

      import ExFacts.System
      import ExFacts.External
    end
  end
end
