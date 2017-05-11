defmodule Facts.Utils do
  @moduledoc """

  `Facts.Utils` contains common logic that is used mostly internally by other modules.

  """
  @spec host_proc :: binary
  def host_proc, do: Path.absname("/proc")

  @spec host_proc(binary) :: binary
  def host_proc(combine_with)  when is_binary(combine_with) do
    if is_nil(System.get_env("HOST_PROC")) do
      Path.join("/proc", combine_with)
    else
      Path.join(System.get_env("HOST_PROC"), combine_with)
    end
  end

  @spec host_sys :: binary
  def host_sys, do: Path.absname("/sys")

  @spec host_sys(binary) :: binary
  def host_sys(combine_with)  when is_binary(combine_with) do
    if is_nil(System.get_env("HOST_SYS")) do
      Path.join("/sys", combine_with)
    else
      Path.join(System.get_env("HOST_SYS"), combine_with)
    end
  end

  @spec host_etc :: binary
  def host_etc, do: Path.absname("/etc")

  @spec host_etc(binary) :: binary
  def host_etc(combine_with)  when is_binary(combine_with) do
    if is_nil(System.get_env("HOST_ETC")) do
      Path.join("/etc", combine_with)
    else
      Path.join(System.get_env("HOST_ETC"), combine_with)
    end
  end

  @type option :: {:sane, boolean}
  @spec read_file(binary, options :: [option]) :: [binary]
  def read_file(filename, options \\ []) do
    defaults = [sane: false]
    opts = Keyword.merge(defaults, options)

    unfiltered =
      with {:ok, file} <- File.open(filename),
        data = IO.binread(file, :all),
        :ok <- File.close(file),
        do: data

    filtered =
      case opts[:sane] do
        true -> unfiltered
                |> String.split("\n")
                |> Enum.filter(& !(String.length(&1) == 0))
        _ -> unfiltered
      end

    filtered
  end

  @spec sanitize_data(binary) :: any
  def sanitize_data("" = data) when is_binary(data), do: ""
  def sanitize_data("\n" = newline) when is_binary(newline), do: ""
  def sanitize_data(data) when is_binary(data) do
    [k, v] =
      data
        |> (&Regex.replace(~r/(\t|\n)+/, &1, "")).()
        |> String.split(":", trim: true)

    Map.put(%{}, k, v)
  end

  @spec normalize_with_underscore(map) :: map
  def normalize_with_underscore(item) when is_map(item) do
    k = item
        |> Map.keys()
        |> Enum.map(fn(x) -> x |> String.trim |> String.downcase |> String.replace(~r/\s+/, "_") end)
        |> hd

    Map.new([{k, hd(Map.values(item))}])
  end

  @spec normalize_with_underscore(tuple) :: tuple
  def normalize_with_underscore(item) when is_tuple(item) do
    k =
      item
        |> elem(0)
        |> String.trim
        |> String.downcase
        |> String.replace(~r/\s+/, "_")

    {k, elem(item, 1)}
  end

  @spec normalize_with_underscore(binary) :: map
  def normalize_with_underscore("" = item) when is_binary(item), do: %{}

  @spec delete_all(list, any) :: list
  def delete_all(list, value) do
    Enum.filter(list, & &1 !== value)
  end

end
