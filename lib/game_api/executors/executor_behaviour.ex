defmodule GameApi.ExecutorBehaviour do
  @moduledoc """
  Predefined behaviors for game types
  """
  @callback insert_game(map()) :: map()
  @callback get_game_by_id(String.t()) :: map()
  @callback get_games_by_name(String.t()) :: map()
  @callback update_game(map(), String.t()) :: map()
end
