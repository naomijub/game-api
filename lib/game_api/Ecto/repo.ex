defmodule GameApi.Repo do
  @moduledoc """
  Module with ecto.repo logic for mongo
  """
  use Ecto.Repo,
    otp_app: :game_api,
    adapter: Mongo.Ecto
end
