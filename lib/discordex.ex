defmodule Discordex do

  @behaviour Discordex.API

  def login(email, password) do
    http.put("auth/login", %{email: email, password: password})
    |> case do
      {:error, _} = error -> error
      {:ok, %{"token" => token}} ->
        {:ok, %Discordex.Client{token: token}}
    end
  end

  defp http do
    Application.get_env(:discordex, :http_client)
  end

end
