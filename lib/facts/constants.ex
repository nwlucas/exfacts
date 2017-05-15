defmodule ExFacts.Constants do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import ExFacts.Constants
    end
  end

  @doc """
  Define a constant
  """
  defmacro const(name, value) do
    quote do
      def unquote(name)(), do: unquote(value)
    end
  end
end
