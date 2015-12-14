defmodule Discordex.SwaggerTest do
  use ExUnit.Case

  defmodule Swag do
    require Discordex.Swagger
    Discordex.Swagger.generate_functions
  end

  test "swagger" do
    assert Swag.get_user("123abc") == "https://discordapp.com/api/users/123abc"
  end

end
