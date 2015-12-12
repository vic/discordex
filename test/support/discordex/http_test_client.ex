defmodule Discordex.HttpTestClient do
  @behaviour Discordex.HttpClient

  def put("auth/login", %{email: "invalid"}) do
    {:error, "invalid credentials"}
  end

  def put("auth/login", %{email: "email", password: "password"}) do
    {:ok, %{"token" => "1234567890"}}
  end

end
