defmodule Discordex.SwaggerTest do
  use ExUnit.Case

  defmodule Swag do
    require Discordex.Swagger
    Discordex.Swagger.generate_functions
  end

  @client %{}

  test "request is made" do
    {:ok, response} = Swag.get_user(@client, user_id: "davoclavo")
    assert response.status_code == 200
  end

  test "missing parameter" do
    assert_raise RuntimeError, fn ->
      Swag.get_user(@client, username: "abc")
    end
  end

  test "set default params" do
    # TODO:
  end

end
