defmodule GameApiWeb.Router do
  use GameApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward "/healthcheck", Healthcheck, resp_body: "WORKING"

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: GameApiWeb.Schema

    forward "/", Absinthe.Plug, schema: GameApiWeb.Schema
  end
end
