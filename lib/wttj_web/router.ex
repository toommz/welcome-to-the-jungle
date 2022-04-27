defmodule WttjWeb.Router do
  use WttjWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WttjWeb do
    pipe_through :api

    head "/", StubController, :index
  end
end
