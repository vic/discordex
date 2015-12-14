defmodule Discordex.Swagger do

  def parse_yaml(filename \\ "swagger.yaml") do
    File.cwd!
    |> Path.join(filename)
    |> YamlElixir.read_from_file
  end

  # Parameters may be reserved keywords :( so we need to add something to avoid that
  # ** (SyntaxError) nofile:1: syntax error before: 'after'
  @param_suffix "_"

  require Logger
  require IEx
  defmacro generate_functions do
    swagger = parse_yaml
    base_url = generate_base_url(swagger)
    swagger["paths"]
    |> Enum.map fn {path, verbs} ->
      verbs
      |> Enum.map fn {verb, request} ->
        verb = verb |> String.to_atom
        function_name = request["operationId"] |> String.to_atom
        parameters = request["parameters"] |> generate_parameters(swagger)
        template_path = path
        |> String.replace("{", ~s(\#\{))
        |> String.replace("}", ~s(#{@param_suffix}\}))
        quoted_path = Code.string_to_quoted!(~s("#{template_path}"))

        # Logger.debug("#{verb} #{template_path} #{inspect parameters}")
        # IO.puts(~s{assert Swag.#{function_name}() == "#{template_path}"})
        # responses = request["responses"]
        quote do
          # @spec parameter_types :: response_types
          def unquote(function_name)(unquote_splicing(parameters)) do
            unquote(base_url) <> unquote(quoted_path)
            # HTTPoison.request(verb, )
          end
        end
      end
    end
  end

  def generate_base_url(swagger) do
    scheme = swagger["schemes"] |> hd
    scheme <> "://" <> swagger["host"] <> swagger["basePath"]
  end

  def generate_parameters(nil, _), do: []
  def generate_parameters(parameters, swagger) do
    parameters
    |> Enum.map(fn parameter ->
      if(ref = parameter["$ref"]) do
        "#/parameters/" <> parameter_name = ref
        parameter = Map.fetch!(swagger["parameters"], parameter_name)
      end
      # parameter["in"]
      # parameter["schema"]
      # parameter["required"]
      parameter["name"] <> @param_suffix
    end)
    |> Enum.map(&Code.string_to_quoted!/1)
  end

end
