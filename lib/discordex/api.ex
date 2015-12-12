defmodule Discordex.API do

  @moduledoc """
  Discord API Behaviour

  http://discordapi-unoffical.readthedocs.org/en/latest/index.html
  """

  @doc "Creates a new discordex client by authenticating email and password"
  @callback login(email :: String.t, password :: String.t) ::
  {:ok, Discordex.Client.t} | {:error, String.t}

end
