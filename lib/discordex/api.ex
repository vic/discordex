defmodule Discordex.API do

  @doc "Creates a new discordex client by authenticating email and password"
  @callback login(email :: String.t, password :: String.t) ::
  {:ok, Discordex.Client.t} | {:error, String.t}

end
