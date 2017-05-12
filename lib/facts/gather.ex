defmodule ExFacts.Gather do
  @moduledoc """
  Provides a common entry point to gather all internal information in one command and returns a serialized JSON reponse.
  """

  @doc """
  Returns the facts of the system in JSON format.

  It calls all underlying modules and aggregates the returned data then formats it in the desired JSON output.
  """
  def get_system_facts do
    IO.puts "#{__MODULE__} called, and function is get_system_facts"
  end

  @doc """
  Returns the facts of the external fact checks in JSON format.

  It calls all underlying modules and aggregates the returned data then formats it in the desired JSON output.
  [WIP]
  """
  def get_external_facts do
    IO.puts "#{__MODULE__} called, and function is get_external_facts"
  end
end
