# ExFacts [![Hex.pm version](https://img.shields.io/hexpm/v/exfacts.svg)](https://hex.pm/packages/exfacts)


## Installation
### mix.exs
Add ExFacts to your list of dependencies

```elixir
def deps do
  [{:exfacts, "~> 0.1.2"}]
end
```

## Usage
In general you can use the `get_external_facts/0` or `get_system_facts/0`. Those function will return JSON data with all fields normalized and containing the data in them.

```elixir
defmodule SomeModule do
  use ExFacts

  def some_function do
    data = get_external_facts()
  end

  def other_function do
    data = get_system_facts()
  end
end
```

But you can also short-circuit to only the functions that return the information that you are looking for.
Aliases have been setup for each of the main areas to help avoid namespacing issues.

* **ExCPU**

* **ExDisk**

* **ExHost**

* **ExLoad**

* **ExMem**

* **ExNet**

```elixir
defmodule SomeModule do
  use ExFacts

  def some_function do
    cpu_data = ExCPU.cpu_info()
  end

  def other_function do
    host_data = ExHost.host_info()
  end
end
```

## Documentation

Online documentation can be found at [https://hexdocs.pm/exfacts](https://hexdocs.pm/exfacts).
