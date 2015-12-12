defmodule Discordex.HttpTestClient do
  @behaviour Discordex.HttpClient

  alias Discordex.TestData

  @valid_email "user@example.com"
  @valid_token "1234567890"

  def put("auth/login", %{email: "invalid"}) do
    {:error, "invalid credentials"}
  end

  def put("auth/login", %{email: @valid_email, password: _}) do
    {:ok, %{"token" => @valid_token}}
  end

  def post("auth/logout", %{token: @valid_token}) do
    {:ok, %{}}
  end

end
