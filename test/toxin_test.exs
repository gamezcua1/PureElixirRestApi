defmodule ToxinTest do
  use ExUnit.Case
  doctest Toxin

  test "greets the world" do
    assert Toxin.hello() == :world
  end
end
