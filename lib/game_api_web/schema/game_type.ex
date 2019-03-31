defmodule GameApiWeb.Schema.GameType do
  @moduledoc """
  Module with Game types for GameApi GraphQL
  Enums,
  Objects,
  Input Objects
  """
  use Absinthe.Schema.Notation

  enum :rating do
    value(:L, as: "L")
    value(:dez, as: "10")
    value(:doze, as: "12")
    value(:quatorze, as: "14")
    value(:dezesseis, as: "16")
    value(:dezoito, as: "18")
  end

  object :game do
    field(:id, :id)
    field(:name, non_null(:string))
    field(:description, non_null(:string))
    field(:rating, :string)
    field(:category, list_of(:string))
    field(:created_date, :string)
    field(:updated_date, :string)
  end

  object :game_list do
    field(:page_info, :page_info)
    field(:game, list_of(:game))
  end

  input_object :game_input do
    field(:name, non_null(:string))
    field(:description, non_null(:string))
    field(:rating, :rating)
    field(:category, non_null(list_of(:string)))
  end

  input_object :game_update_input do
    field(:name, :string)
    field(:description, :string)
    field(:rating, :rating)
    field(:category, list_of(:string))
  end
end
