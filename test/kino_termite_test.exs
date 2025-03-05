defmodule KinoTermiteTest do
  use ExUnit.Case
  doctest KinoTermite

  test "greets the world" do
    assert KinoTermite.hello() == :world
  end
end
