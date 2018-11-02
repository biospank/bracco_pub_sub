defmodule BraccoPubSubTest do
  use ExUnit.Case
  doctest BraccoPubSub

  test "greets the world" do
    assert BraccoPubSub.hello() == :world
  end
end
