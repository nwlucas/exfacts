defmodule ExFacts.UtilsTest do
  import ExFacts.Utils
  use ExUnit.Case, async: true
  doctest ExFacts.Utils

  describe "normalize_with_underscore/1" do
    test "given a map" do
      assert %{"some_key_with_spaces" => "Some value"} == normalize_with_underscore(%{"some key with Spaces"=>"Some value"})
    end
    test "given a tuple" do
      assert {"a_tuple_with_spaces", "another Item"} == normalize_with_underscore({"a tuple with spaces", "another Item"})
    end
    test "given an empty binary" do
      assert %{} == normalize_with_underscore("")
    end
  end

  describe "sanitize_data/1" do
    test "given a binary with only a newline character" do
      assert "" == sanitize_data("\n")
    end
    test "given a binary" do
      assert %{"Randomtext" => "interlacedwithescapecharacters"} == sanitize_data("Random\ttext    :    \ninterlaced\t\nwith\tescape\n\ncharacters     ")
    end
    test "given an empty binary" do
      assert "" == sanitize_data("")
    end
  end
end
