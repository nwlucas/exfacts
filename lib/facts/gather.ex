defmodule ExFacts.Gather do
  @moduledoc """
  Provides a common entry point to gather all internal information in one command and returns a serialized JSON reponse.
  """

  def get_system_facts do
    IO.puts "#{__MODULE__} called, and function is get_system_facts"
  end

  def get_external_facts do
    IO.puts "#{__MODULE__} called, and function is get_external_facts"
  end
end
