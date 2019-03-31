defmodule GameApiWeb.Schema.OrderType do
  @moduledoc """
  Module with Order types for input in GameApi GraphQL
  Enums,
  Input Objects
  """
  use Absinthe.Schema.Notation

  enum :order_sequence do
    value(:asc)
    value(:desc)
  end

  enum :order_parameter do
    value(:id)
    value(:name)
  end

  input_object :order_input do
    field(:order_sequence, :order_sequence)
    field(:order_parameter, :order_parameter)
  end

  object :page_info do
    field(:total_entries, :integer)
    field(:total_pages, :integer)
    field(:per_page, :integer)
    field(:offset, :integer)
    field(:previous_page, :integer)
    field(:current_page, :integer)
    field(:next_page, :integer)
  end
end
