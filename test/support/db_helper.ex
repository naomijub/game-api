defmodule GameApi.DbHelpers do
  @moduledoc """
  Simple helper to query on GraphQL
  """

  def clean_up do
    import Ecto.Query, only: [from: 2]
    alias GameApi.Repo

    query =
      from(t in GameApi.Game,
        where: not is_nil(t.id)
      )

    Repo.delete_all(query)
    Process.sleep(1000)
  end
end
