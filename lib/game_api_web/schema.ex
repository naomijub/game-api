defmodule GameApiWeb.Schema do
  @moduledoc """
  Module with GameApi GraphQL Queries
  and Mutations
  """

  use Absinthe.Schema
  import_types(GameApiWeb.Schema.GameType)
  import_types(GameApiWeb.Schema.OrderType)

  alias GameApiWeb.Resolvers

  query do
    @desc "Get games by name"
    field :games_by_name, list_of(:game) do
      arg(:name, non_null(:string))

      resolve(&Resolvers.Game.get_games_by_name/3)
    end

    @desc "Get game by id"
    field :game_by_id, :game do
      arg(:id, non_null(:string))

      resolve(&Resolvers.Game.get_game_by_id/3)
    end
  end

  mutation do
    @desc "Create a game"
    field :create_game, type: :game do
      arg(:game, :game_input)

      resolve(&Resolvers.Game.create_game/3)
    end

    @desc "Update a game"
    field :update_game, type: :game do
      arg(:game, non_null(:game_update_input))
      arg(:id, :string)

      resolve(&Resolvers.Game.update_game/3)
    end
  end
end
