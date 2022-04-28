defmodule WttjWeb.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias WttjWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Welcome to the Jungle - Technica Test API",
        version: "1.0"
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules() # Discover request/response schemas from path specs
  end

  defmacro sort_schema(sortable_fields) do
    quote location: :keep do
      enum =
        unquote(sortable_fields)
        |> Enum.flat_map(& ["#{&1}", "-#{&1}"])

      require OpenApiSpex

      OpenApiSpex.schema %{
        type: :array,
        minItems: 1,
        items: %OpenApiSpex.Schema{
          type: :string,
          enum: enum
        }
      }
    end
  end
end
