defmodule ExFacts.Constants do
  @moduledoc """
  An alternative to use @constant_name value approach to defined reusable
  constants in elixir.
  This module offers an approach to define these in a
  module that can be shared with other modules. They are implemented with
  macros so they can be used in guards and matches
  ## Examples:
  Create a module to define your shared constants
      defmodule MyConstants do
        use Constants
        define something,   10
        define another,     20
      end
  Use the constants
      defmodule MyModule do
        require MyConstants
        alias MyConstants, as: Const
        def myfunc(item) when item == Const.something, do: Const.something + 5
        def myfunc(item) when item == Const.another, do: Const.another
      end
  """

  defmacro __using__(_opts) do
    quote do
      import ExFacts.Constants
    end
  end

  @doc "Define a constant"
  defmacro const(name, value) do
    quote do
      def unquote(name)(), do: unquote(value)
    end
  end
end
