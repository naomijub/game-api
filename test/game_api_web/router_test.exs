defmodule GameApiWeb.RouterTest do
  use ExUnit.Case
  use GameApiWeb.ConnCase

  describe "Healthcheck" do
    @tag :functional
    test "Healthcheck returns WORKING", context do
      res = get(context.conn, "/healthcheck")

      assert res.resp_body == "WORKING"
    end
  end
end
