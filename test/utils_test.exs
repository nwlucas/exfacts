defmodule exFacts.UtilsTest do
  import ExFacts.Utils
  use ExUnit.Case
  doctest ExFacts.Utils

  describe "Test functionality of ExFacts.Utils" do
    test "proper path to proc in host_proc/0" do
      assert "/proc" = host_proc()
    end

    test "proper path to proc in host_proc/1" do
      assert "/proc/some_directory" = host_proc("some_directory")
    end

    test "proper path to sys in host_sys/0" do
      assert "/sys" = host_sys()
    end

    test "proper path to proc in host_sys/1" do
      assert "/sys/some_directory" = host_sys("some_directory")
    end

    test "proper path to etc in host_etc/0" do
      assert "/etc" = host_etc()
    end

    test "proper path to etc in host_etc/1" do
      assert "/etc/some_directory" = host_etc("some_directory")
    end
  end
end
