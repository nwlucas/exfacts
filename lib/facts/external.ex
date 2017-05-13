defmodule ExFacts.External do
  alias ExFacts.{CPU, Disk, Host, Load, Mem, Net}
  @moduledoc """
  Provides a common entry point to gather all external information in one command and returns a serialized JSON reponse.
  """

  @doc """
  Returns the facts of the external fact checks in JSON format.

  It calls all underlying modules and aggregates the returned data then formats it in the desired JSON output.
  [WIP]
  """
  def gather_external do
    IO.puts "#{__MODULE__} called, and function is get_external_facts"
  end
end
