defmodule GameApi.AbsintheHelpers do
  @moduledoc """
  Simple helper to query on GraphQL
  """

  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  def mutation_skeleton(query) do
    %{
      "query" => "mutation #{query}",
      "variables" => "{}"
    }
  end
end
