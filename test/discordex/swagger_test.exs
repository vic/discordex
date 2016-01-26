defmodule Discordex.SwaggerTest do
  use ExUnit.Case

  defmodule Swag do
    require Discordex.Swagger
    Discordex.Swagger.generate_functions
  end

  test "swagger" do
    assert Swag.get_user("1", user_id: "123abc") == "https://discordapp.com/api/users/123abc"
  end

  test "missing parameter" do
    # TODO: Create proper Error
    assert_raise RuntimeError, fn ->
      Swag.get_user("1", username: "abc")
    end
  end

end
