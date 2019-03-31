defmodule GameApiWeb.Resolvers.Game do
  @moduledoc """
  Module with GameApi with games
  GraphQL resolvers
  """

  @game_api Application.get_env(:game_api, :game)
  def create_game(_parent, %{game: game}, _resolution) do
    {:ok, @game_api.insert_game(game)}
  end

  def get_games_by_name(_parent, %{name: name}, _resolution) do
    {:ok, @game_api.get_games_by_name(name)}
  end

  def get_game_by_id(_parent, %{id: id}, _resolution)
      when not is_binary(id) or byte_size(id) != 24 do
    {:error, "ID format is incorrect, passed #{id}"}
  end

  def get_game_by_id(_parent, %{id: id}, _resolution) do
    {:ok, @game_api.get_game_by_id(id)}
  end

  def update_game(_parent, %{game: game, id: _id}, _resolution) when map_size(game) == 0 do
    {:error, "Game should contain at least 1 parameter"}
  end

  def update_game(_parent, %{game: _game, id: id}, _resolution)
      when not is_binary(id) or byte_size(id) != 24 do
    {:error, "ID format is incorrect, passed #{id}"}
  end

  def update_game(_parent, %{game: game, id: id}, _resolution) do
    case @game_api.update_game(game, id) do
      {:ok, updated_game} -> {:ok, updated_game}
      {:error, message} -> {:error, message}
    end
  end
end
