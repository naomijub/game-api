defmodule GameApi.GameTest do
  use ExUnit.CaseTemplate
  use ExUnit.Case
  import Game.Factory
  alias GameApi.Game

  setup_all do
    GameApi.DbHelpers.clean_up()
    on_exit(fn -> GameApi.DbHelpers.clean_up() end)
  end

  describe "Insert Game" do
    @tag :integration
    test "insert_game/1 game map into mongo" do
      expected_game = params_for(:game)
      inserted_game = Game.insert_game(expected_game)

      assert inserted_game.name == expected_game.name
      assert inserted_game.id != nil
      assert String.length(inserted_game.id) > 10
      assert inserted_game.description == expected_game.description
      assert inserted_game.category == expected_game.category
      assert inserted_game.rating == expected_game.rating
    end
  end

  describe "Update Game" do
    @tag :integration
    test "update_game/2 game map into mongo" do
      expected_game = params_for(:game)
      update_game = params_for(:game, %{name: "Charmander", description: "Snorlax"})
      inserted_game = Game.insert_game(expected_game)
      {:ok, updated_game} = Game.update_game(update_game, inserted_game.id)

      assert inserted_game.name != updated_game.name
      assert updated_game.name == "Charmander"
      assert inserted_game.id == updated_game.id
    end

    @tag :integration
    test "update_name/2 returns error for id not found" do
      {:error, message} = Game.update_game(params_for(:game), "5c9a735cd1fb7b040117559a")

      assert message == "ID: 5c9a735cd1fb7b040117559a was not found on database"
    end
  end

  describe "Game by ID" do
    @tag :integration
    test "get_game_by_id/1 queries correct id from map // tests created date", context do
      game1 = params_for(:game)
      game2 = params_for(:game)
      inserted_game1 = Game.insert_game(game1)
      inserted_game2 = Game.insert_game(game2)

      result1 = Game.get_game_by_id(inserted_game1.id)
      result2 = Game.get_game_by_id(inserted_game2.id)

      assert result1.id == inserted_game1.id
      assert result1.name == game1.name
      assert result2.id == inserted_game2.id
      assert result1.created_date == inserted_game1.created_date

      assert Regex.match?(
               ~r/\b\d{4}-?\d{2}-?\d{2}-? \d{2}:\d{2}:\d{2}.\d{3,}Z\b/,
               result1.created_date
             )
    end
  end

  describe "Games by Name" do
    @tag :integration
    test "get_games_by_name/1 queries correct games by name", context do
      game1 = params_for(:game, name: "Charizard")
      game2 = params_for(:game, name: "Charizard")
      inserted_game1 = Game.insert_game(game1)
      inserted_game2 = Game.insert_game(game2)

      games = Game.get_games_by_name("Charizar")
      [head | [neck | _]] = games

      assert head.id == inserted_game1.id
      assert neck.id == inserted_game2.id
    end
  end
end
