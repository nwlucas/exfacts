defmodule ExFacts.UtilsTest do
  import ExFacts.Utils
  use ExUnit.Case, async: true
  doctest ExFacts.Utils

  describe "Ensure paths are being determined correctly" do

    test "path to /etc" do
      path = Path.expand host_etc()
      expected_path = Path.expand Application.get_env(:exfacts, :etc_path)

      assert expected_path == path
    end

    test "path to a file in /etc" do
      path = Path.expand host_etc("test_file")
      expected_path = Path.expand Application.get_env(:exfacts, :etc_path)

      assert expected_path <> "/test_file" == path
    end

    test "path to /proc" do
      path = Path.expand host_proc()
      expected_path = Path.expand Application.get_env(:exfacts, :proc_path)

      assert expected_path == path
    end

    test "path to a file in /proc" do
      path = Path.expand host_proc("test_file")
      expected_path = Path.expand Application.get_env(:exfacts, :proc_path)

      assert expected_path <> "/test_file" == path
    end

    test "path to /sys" do
      path = Path.expand host_sys()
      expected_path = Path.expand Application.get_env(:exfacts, :sys_path)

      assert expected_path == path
    end

    test "path to a file in /sys" do
      path = Path.expand host_sys("test_file")
      expected_path = Path.expand Application.get_env(:exfacts, :sys_path)

      assert expected_path <> "/test_file" == path
    end
  end

  describe "read_file/1" do
    test "reading in a file, with default options" do
      path = Path.expand host_proc("test_file")
      expected = "This is line 1\nThis is line 2\nAnother line here\nYet another\n"

      assert expected == read_file(path)
    end

    test "reading in a file, with sane: true" do
      path = Path.expand host_proc("test_file")
      expected = ["This is line 1", "This is line 2", "Another line here", "Yet another"]

      assert expected == read_file(path, sane: true)
    end
  end

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
