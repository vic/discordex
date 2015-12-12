Code.require_file "../../test_helper.exs", __DIR__

defmodule Discordex.API.AuthenticationTest do
  use ExUnit.Case
  doctest Discordex.API

  alias Discordex, as: API

  test ".login returns error on invalid credentials" do
    assert {:error, _} = API.login("invalid", "password")
  end

  test ".login returns Discordex.Client for valid credentials" do
    assert {:ok, client} = API.login("email", "password")
    assert %{__struct__: Discordex.Client} = client
  end

end
