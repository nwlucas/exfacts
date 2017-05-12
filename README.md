# ExFacts [![hex.pm version](https://img.shields.io/hexpm/v/exfacts.svg)](https://hex.pm/packages/exfacts)


## Installation

```elixir
def deps do
  [{:exfacts, "~> 0.1.2"}]
end
```

## Usage
In general you can use the `Facts.get_external_facts/0` or `Facts.get_system_facts/0`. Those function will return JSON data with all fields normalized and containing the data in them.

```elixir
defmodule SomeModule do

  def some_function do
    Facts.get_external_facts
  end

  def other_function do
    Facts.get_system_facts
  end
end
```

## Documentation

Online documentation can be found at [https://hexdocs.pm/exfacts](https://hexdocs.pm/exfacts).
