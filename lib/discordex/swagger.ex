defmodule Discordex.Swagger do

  # Specify an external resource to the current module to recompile in case it changes
  @external_resource "swagger.yaml"

  def parse_yaml(filename \\ @external_resource) do
    File.cwd!
    |> Path.join(filename)
    |> YamlElixir.read_from_file
  end

  require Logger
  require IEx
  defmacro generate_functions do
    swagger = parse_yaml
    quote location: :keep do
      unquote(defendpoints(swagger))
    end
  end

  defp defendpoints(swagger) do
    swagger["paths"]
    |> Enum.map(fn {path, verbs} ->
      verbs
      |> Enum.map(fn {verb, config} ->
        function_name = config["operationId"] |> String.to_atom
        verb = verb |> String.to_atom
        swagger_params = config["parameters"] |> expand_params(swagger) |> Macro.escape
        defendpoint(swagger, function_name, verb, path, swagger_params)

        # Logger.debug("#{function_name}: #{verb} #{template_path} #{inspect params}")
      end)
    end)
  end

  defp defendpoint(swagger, function_name, verb, path, swagger_params) do
    quote location: :keep do
      # @spec parameter_types :: response_types

      def unquote(function_name)(client, raw_params) do
        params = raw_params
        |> Discordex.Swagger.check_required_params!(unquote(swagger_params))
        # |> Discordex.Swagger.set_default_params(unquote(swagger_params))

        # Set request parameteres
        # case param["in"] do
        #   "query" ->
        #     # /items?id=###
        #     nil
        #   "header" ->
        #     client
        #     nil
        #   "body" ->
        #     nil
        #   "form" ->
        #     nil
        # end

        # Render path
        rendered_path = Discordex.Swagger.render_path(unquote(path), params)

        # Generate full url
        full_url = unquote(base_url(swagger)) <> rendered_path

        body = ""
        headers = []
        options = []

        HTTPoison.request(unquote(verb), full_url, body, headers, options)
      end
    end
  end

  def check_required_params!(params, swagger_params) do
    IO.inspect swagger_params
    missing_params = Enum.flat_map(swagger_params, fn(swagger_param) ->
      param_key = String.to_atom(swagger_param["name"])

      # Enforce required parameter
      if swagger_param["required"] && !Keyword.has_key?(params, param_key) do
        [param_key]
      else
        []
      end
    end)

    if length(missing_params) > 0 do
      raise "Missing parameters: #{inspect(missing_params)}"
    end

    params
  end

  def set_default_params(params, swagger_params) do
    swagger_params
    |> Enum.reduce(params, fn(swagger_param, params) ->
      param_key = String.to_atom(swagger_param["name"])
      if swagger_param["default"] do
        Keyword.update(params, param_key, swagger_param["default"], &(&1))
      else
        params
      end
    end)
  end

  # # A path may contain template segments like /users/{user-id}/ so we replace those
  def render_path(path, path_params) do
    ~r/(?<head>){[^\}]+}(?<tail>)/
    |> Regex.split(path, on: [:head, :tail])
    |> Enum.reduce("", fn
      "{" <> path_param, acc ->
        key = path_param
        |> String.rstrip(?\})
        |> String.to_atom
        # Render segment with binding from `params`
        acc <> to_string(Dict.fetch!(path_params, key))

      segment, acc ->
        # Append segment to the path
        acc <> segment
    end)
  end

  def base_url(swagger) do
    # TODO: Support more than 1 scheme
    scheme = swagger["schemes"] |> hd
    scheme <> "://" <> swagger["host"] <> swagger["basePath"]
  end

  # # A parameter may be a reference like '#/parameter/user-id' so we expand those
  def expand_params(nil, _), do: []
  def expand_params(params, swagger) do
    for param <- params do
      if(ref = param["$ref"]) do
        "#/parameters/" <> param_name = ref

        # Replace with root definition
        param = Map.fetch!(swagger["parameters"], param_name)
      end
      param
    end
  end
end
