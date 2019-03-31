ExUnit.start()
Mox.defmock(GameApi.GameMock, for: GameApi.ExecutorBehaviour)

defmodule TestHelper do
  use ExUnit.Case
  use GameApiWeb.ConnCase
  alias GameApi.AbsintheHelpers

  def request(conn, query, query_name) do
    conn
    |> post("/api/graphiql", AbsintheHelpers.query_skeleton(query, query_name))
    |> json_response(200)
  end

  def mutate(conn, mutation) do
    conn
    |> post("/api/graphiql", AbsintheHelpers.mutation_skeleton(mutation))
    |> json_response(200)
  end

  def query(%{page: page, per_page: per_page}) do
    """
    {paginateGamesWithFilters(page:#{page}, perPage: #{per_page})
      {game{id, name}
      pageInfo{perPage, currentPage, totalPages, totalEntries, offset}
      }}
    """
  end
end
