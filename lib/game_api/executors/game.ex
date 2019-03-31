defmodule GameApi.Game do
  @moduledoc """
  Module with GameApi.Game Ecto Schema
  and queries
  """
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias Mongo.Ecto.Helpers
  alias GameApi.ExecutorBehaviour

  @behaviour ExecutorBehaviour

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game" do
    field(:name, :string)
    field(:description, :string)
    field(:rating, :string)
    field(:category, {:array, :string})
    field(:created_date, :string)
    field(:updated_date, :string)
  end

  @impl ExecutorBehaviour
  def insert_game(game) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    datetime_map = %{created_date: to_string(datetime), updated_date: to_string(datetime)}

    game
    |> game_default_map(datetime_map)
    |> GameApi.Repo.insert!()
  end

  @impl ExecutorBehaviour
  def update_game(query_game, query_id) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    change_game_map = Enum.into(%{updated_date: to_string(datetime)}, query_game)
    game = GameApi.Repo.get(GameApi.Game, query_id)

    case game do
      %{id: id} when id == query_id -> change_game(game, change_game_map)
      nil -> {:error, "ID: #{query_id} was not found on database"}
    end
  end

  @impl ExecutorBehaviour
  def get_game_by_id(query_id) do
    query =
      from(t in GameApi.Game,
        where: t.id == ^query_id,
        select: t
      )

    List.first(GameApi.Repo.all(query))
  end

  @impl ExecutorBehaviour
  def get_games_by_name(query_name) do
    regex = Helpers.regex(query_name, "i")

    query =
      from(t in GameApi.Game,
        where: fragment(name: ^regex),
        select: t
      )

    GameApi.Repo.all(query)
  end

  def game_default_map(game, datetime) do
    game
    |> Map.take(Map.keys(game))
    |> Enum.into(datetime)
    |> Enum.into(%GameApi.Game{})
  end

  defp change_game(game, change_game_map) do
    change_game = Ecto.Changeset.change(game, change_game_map)

    case GameApi.Repo.update(change_game) do
      {:ok, struct} -> {:ok, struct}
      {:error, _} -> {:error, "Game: #{change_game_map} could not be updated"}
    end
  end

  defimpl Collectable, for: GameApi.Game do
    def into(original) do
      {original,
       fn
         map, {:cont, {k, v}} -> :maps.put(k, v, map)
         map, :done -> map
         _, :halt -> :ok
       end}
    end
  end
end
