defmodule GameApiWeb.GameResolverTest do
  use GameApiWeb.ConnCase
  use ExUnit.Case
  import Mox
  import Game.Factory

  setup :verify_on_exit!

  describe "Get Game by ID Resolver" do
    @tag :functional
    test "get_game_by_id/3 returns a name for existing ID", context do
      game1 = build(:game, id: "5c9a735cd1eb7b000117559a")
      expect(GameApi.GameMock, :get_game_by_id, fn "5c9a735cd1eb7b000117559a" -> game1 end)

      res = TestHelper.request(context.conn, query_id("5c9a735cd1eb7b000117559a"), "game")

      assert res["data"]["gameById"]["id"] == to_string(game1.id)
      assert res["data"]["gameById"]["name"] == to_string(game1.name)
      assert res["data"]["gameById"]["description"] == to_string(game1.description)
      assert res["data"]["gameById"]["category"] == game1.category

      assert res["data"]["gameById"]["rating"] ==
               game1.rating
    end

    @tag :functional
    test "get_game_by_id/3 returns a null for incorrect ID", context do
      expect(GameApi.GameMock, :get_game_by_id, fn "5c866e83a1b087000186a669" -> nil end)

      res = TestHelper.request(context.conn, query_id("5c866e83a1b087000186a669"), "game")

      assert res["data"]["gameById"] == nil
    end

    @tag :functional
    test "get_game_by_id/3 returns error for invalid ID", context do
      res = TestHelper.request(context.conn, query_id("ERROR"), "game")
      [query_error | _] = res["errors"]
      assert query_error["message"] == "ID format is incorrect, passed ERROR"
    end
  end

  describe "Get Games by Name Resolver" do
    @tag :functional
    test "get_games_by_name/3 returns a list of names for existing name", context do
      game1 = build(:game, %{id: "5c9a735cd1eb7b000117559a", name: "Pikachu"})
      game2 = build(:game, %{id: "5c9d735cd1eb7b000117559a", name: "Pikachu"})
      expect(GameApi.GameMock, :get_games_by_name, fn "Pikachu" -> [game1, game2] end)

      query = """
      {gamesByName(name: "Pikachu"){
        name
        id
      }}
      """

      res = TestHelper.request(context.conn, query, "game")

      [head | [neck | _]] = res["data"]["gamesByName"]
      assert length(res["data"]["gamesByName"]) == 2
      assert head["id"] == game1.id
      assert neck["id"] == game2.id
      assert head["name"] == game1.name
    end
  end

  describe "Create Game Resolver" do
    @tag :functional
    test "create_game/3 creates a name with required attributes", context do
      game1 = params_for(:game)
      GameApi.GameMock
      |> expect(:insert_game, fn _ -> game1 end)

      mutation = create_mutation()
      res = TestHelper.mutate(context.conn, mutation)

      created_game = res["data"]["createGame"]
      assert created_game["name"] == game1.name
      assert created_game["description"] == game1.description
      assert created_game["category"] == game1.category
      assert created_game["rating"] == game1.rating
    end

    @tag :functional
    test "create_game/3 returns error message for null required fields", context do
      mutation = """
        {createGame(game:
        {
          rating: DEZ
        }){
          name
        }
      }
      """

      expected =
         "Argument \"game\" has invalid value {rating: DEZ}.\nIn field \"name\": Expected type \"String!\", found null.\nIn field \"description\": Expected type \"String!\", found null.\nIn field \"category\": Expected type \"[String]!\", found null."

      res = TestHelper.mutate(context.conn, mutation)

      [error_name | _] = res["errors"]
      assert error_name["message"] == expected
    end
  end

  describe "Update Game Resolver" do
    @tag :functional
    test "update_game/3 updates a name with attributes", context do
      insert_game = params_for(:game, %{id: "5c9a735cd1eb7b000117559a", updated_date: "2019-03-26 18:50:48.867762Z"})
      update_game = params_for(:game, %{name: "UPDATE", id: "5c9a735cd1eb7b000117559a", updated_date: "2019-05-26 18:50:48.867762Z"})

      GameApi.GameMock
      |> expect(:insert_game, fn _ -> insert_game end)
      |> expect(:update_game, fn _, _ -> {:ok, update_game} end)

      created_mutation = TestHelper.mutate(context.conn, create_mutation())
      Process.sleep(1000)

      updated_mutation =
        TestHelper.mutate(
          context.conn,
          update_mutation("5c9a735cd1eb7b000117559a")
        )

      created_game = created_mutation["data"]["createGame"]
      updated_game = updated_mutation["data"]["updateGame"]

      assert created_game["id"] == updated_game["id"]
      assert created_game["name"] != updated_game["name"]
      assert updated_game["name"] == "UPDATE"
      assert created_game["createdDate"] == updated_game["createdDate"]
      assert created_game["updatedDate"] < updated_game["updatedDate"]
    end

    @tag :functional
    test "update_game/3 returns error message for invalid id in updates a game", context do
      updated_mutation =
        TestHelper.mutate(
          context.conn,
          update_mutation("ERROR")
        )

      [updated_error | _] = updated_mutation["errors"]

      assert updated_error["message"] == "ID format is incorrect, passed ERROR"
      assert updated_error["path"] == ["updateGame"]
    end

    @tag :functional
    test "update_game/3 send empty game to updates a game", context do
      mutation = "{updateGame(id: \"5c944a386628eb0001012666\", game: {}){name}}"

      updated_mutation =
        TestHelper.mutate(
          context.conn,
          mutation
        )

      [updated_error | _] = updated_mutation["errors"]

      assert updated_error["message"] == "Game should contain at least 1 parameter"
      assert updated_error["path"] == ["updateGame"]
    end
  end

  defp create_mutation do
    """
      {createGame(game:
        {name: "Teste",
          description: "descrição",
          category: ["RPG"],
          rating: DEZOITO,
        }){
        name
        description
        id
        category
        rating
        createdDate
        updatedDate
      }
    }
    """
  end

  defp update_mutation(id) do
    """
      {updateGame(id: "#{id}", game: {name: "UPDATE"})
        {
          name
          description
          id
          category
          rating
          createdDate
          updatedDate
        }
      }
    """
  end

  defp query_id(id) do
    """
    {gameById(id: "#{id}"){
      name
      description
      id
      category
      rating
    }}
    """
  end
end
