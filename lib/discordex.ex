defmodule Discordex do

  @behaviour Discordex.API

  @spec login(String.t, String.t) ::
  {:error, String.t} | {:ok, Discordex.Client.t}
  def login(email, password) do
    http.put("auth/login", %{email: email, password: password})
    |> case do
      {:error, _} = error -> error
      {:ok, %{"token" => token}} ->
        {:ok, %Discordex.Client{token: token}}
    end
  end

  @spec logout(Discordex.Client.t) ::
  {:error, String.t} | :ok
  def logout(client) do
    http.post("auth/logout", %{token: client.token})
    |> case do
      {:ok, _} -> :ok
    end
  end

  defp http do
    Application.get_env(:discordex, :http_client)
  end

end
