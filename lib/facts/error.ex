defmodule ExFacts.Error do
  @moduledoc """
  Custom errors/exceptions are handled here.
  """
  defexception [:reason]

  def execption(reason), do: %__MODULE__{reason: reason}
  def message(%__MODULE__{reason: reason}), do: reason

end
