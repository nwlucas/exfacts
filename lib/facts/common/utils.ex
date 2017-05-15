defmodule ExFacts.Utils do
  @moduledoc """
  Contains common logic that is used mostly internally by other modules.
  """

  @etc_path Application.get_env(:exfacts, :etc_path, "/etc")
  @proc_path Application.get_env(:exfacts, :proc_path, "/proc")
  @sys_path Application.get_env(:exfacts, :sys_path, "/sys")

  @doc """
  Returns the path to /etc on the filesystem.

  Defaults to /etc and is only evaluated at compile time.
  Note: When MIX_ENV=test it defaults to __DIR <> /test/files/etc
  """
  @spec host_etc :: binary
  def host_etc, do: Path.absname(@etc_path)

  @doc """
  Returns the path to somefile in /etc on the filesystem.

  Defaults to /etc/somefile, it can also be overriden at runtime via environment variables.
  Note: When MIX_ENV=test it defaults to __DIR <> /test/files/etc/somefile
  """
  @spec host_etc(binary) :: binary
  def host_etc(combine_with)  when is_binary(combine_with) do
    if is_nil(System.get_env("HOST_ETC")) do
      Path.join(@etc_path, combine_with)
    else
      Path.join(System.get_env("HOST_ETC"), combine_with)
    end
  end

  @doc """
  Returns the path to /proc on the filesystem.

  Defaults to /proc and is only evaluated at compile time.
  Note: When MIX_ENV=test it defaults to __DIR <> /test/files/proc
  """
  @spec host_proc :: binary
  def host_proc, do: Path.absname(@proc_path)

  @doc """
  Returns the path to somefile in /proc on the filesystem.

  Defaults to /proc/somefile, it can also be overriden at runtime via environment variables.
  Note: When MIX_ENV=test it defaults to __DIR <> /test/files/proc
  """
  @spec host_proc(binary) :: binary
  def host_proc(combine_with)  when is_binary(combine_with) do
    if is_nil(System.get_env("HOST_PROC")) do
      Path.join(@proc_path, combine_with)
    else
      Path.join(System.get_env("HOST_PROC"), combine_with)
    end
  end

  @doc """
  Returns the path to /sys on the filesystem.

  Defaults to /sys and is only evaluated at compile time.
  Note: When MIX_ENV=test it defaults to __DIR <> /test/files/sys
  """
  @spec host_sys :: binary
  def host_sys, do: Path.absname(@sys_path)

  @doc """
  Returns the path to somefile in /sys on the filesystem.

  Defaults to /sys/somefile, can also be overriden at runtime via environment variables.
  Note: When MIX_ENV=test it defaults to __DIR <> /test/files/etc
  """
  @spec host_sys(binary) :: binary
  def host_sys(combine_with)  when is_binary(combine_with) do
    if is_nil(System.get_env("HOST_SYS")) do
      Path.join(@sys_path, combine_with)
    else
      Path.join(System.get_env("HOST_SYS"), combine_with)
    end
  end

  @doc """
  Reads in a file at the path provided in the binary using the binread method. This allows
  the caller to be able to read files that are provided by kernal calls that are not usual
  files.

  If `sane: true` is passed then read in data is also split by new line characters and
  returned as a list of each line.
  """
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

  @doc false
  @spec sanitize_data(binary) :: any
  def sanitize_data("" = data) when is_binary(data), do: ""
  def sanitize_data("\n" = newline) when is_binary(newline), do: ""
  def sanitize_data(data) when is_binary(data) do
    [k, v] =
      data
        |> (&Regex.replace(~r/(\t|\n)+/, &1, "")).()
        |> String.split(":", trim: true)
        |> Enum.map(& String.trim(&1))

    Map.put(%{}, k, v)
  end

  @doc """
  Normalizes keys to thier downcased, snake case version.
  """
  @spec normalize_with_underscore(map) :: map
  def normalize_with_underscore(item) when is_map(item) do
    k = item
        |> Map.keys()
        |> Enum.map(fn(x) -> x |> String.trim |> String.downcase |> String.replace(~r/\s+/, "_") end)
        |> hd

    Map.new([{k, hd(Map.values(item))}])
  end

  @doc """
  Normalizes the first element in the tuple to its downcased, snake case version.
  """
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

  @doc """
  Returns an empty map if the binary itself is empty.
  """
  @spec normalize_with_underscore(binary) :: map
  def normalize_with_underscore("" = item) when is_binary(item), do: %{}

  @doc """
  Iterates through a list and removes any items that math the argument.
  If the argument given is not in the specified list it returns the original list.

  ## Examples

      iex> ["Some", "items", "are", "here"] |> delete_all("are")
      ["Some", "items", "here"]

      iex> ["Some", "items", "are", "are", "here"] |> delete_all("are")
      ["Some", "items", "here"]

      iex> ["Some", "items", "are", "here"] |> delete_all("foo")
      ["Some", "items", "are", "here"]
  """
  @spec delete_all(list, any) :: list
  def delete_all(list, value) do
    Enum.filter(list, & &1 !== value)
  end

  @doc """
  Determines is the argument is a path, executable that exists on the host.
  Returns:

  {:ok, path} for a success
  {:error, "Path or executable not found"} for failures

  ## Examples

      iex> look_path("/")
      {:ok, "/"}

      iex> look_path("/somearbtritrailylongpaththatprobablyshouldnotexist")
      {:error, "Path or executable not found"}
  """
  @spec look_path(binary) :: {:ok, String.t} | {:error, String.t}
  def look_path, do: raise "#{__MODULE__} no path provided"
  def look_path("" = _path), do: raise "#{__MODULE__} empty path provided"
  def look_path(path) do
    p = Path.expand path
    if File.exists?(p) do
      {:ok, p}
    else
      {:error, "Path or executable not found"}
    end
  end

  @doc """
  Internal wrapper function to convert binary to float, using `Float.parse/1`.
  If the item is solely an unparsable binary it is returned untouched, otherwise
  only the float element of the resultant tuple is returned.
  """
  @spec parse_float(String.t) :: Float.t | String.t
  def parse_float(item) do
    case Float.parse item do
      {k, _v} when is_float(k) -> k
      {k, _v} when is_number(k) -> k
      :error -> item
    end
  end
end
