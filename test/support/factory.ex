defmodule Game.Factory do
  @moduledoc """
  A Factory for Title Types
  """
  use ExMachina.Ecto, repo: Game.Repo

  def game_factory do
    %GameApi.Game{
      rating: sequence(:rating, ["L", "10", "12", "14", "16", "18"]),
      description: "descrição",
      category: [
        sequence(:category, ["RPG", "Ação", "RTS", "FPS"])
      ],
      name: sequence("Game ")
    }
  end
end
