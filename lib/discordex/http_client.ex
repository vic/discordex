defmodule Discordex.HttpClient do

  @callback put(uri :: String.t, body :: Map.t) ::
  {:ok, Keyword.t} | {:error, String.t}

end
