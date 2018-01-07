defmodule CraftersWeb.PageController do
  use CraftersWeb, :controller

  def current_month(conn, _params) do
    month = Crafters.Survey.get_current_month
    render conn, "month.html", month: month
  end

  def index(conn, _params) do
    months = Crafters.Survey.get_all_months()
    render conn, "index.html", months: months
  end

  def new_month(conn, _params) do
    render conn, "new_month.html", changeset: Crafters.Survey.new_month()
  end

  def create_month(conn, %{"month" => month}) do
    Crafters.Survey.put_month(month)
    redirect conn, to: page_path(conn, :index)
  end

  def delete_month(conn, %{"id" => id}) do
    Crafters.Survey.delete_month(id)
    redirect conn, to: page_path(conn, :index)
  end

  def month(conn, %{"id" => id}) do
    month = Crafters.Survey.get_month!(id)
    render conn, "month.html", month: month
  end

  def set_current_month(conn, %{"id" => id}) do
    Crafters.Survey.set_current_month(id)
    redirect conn, to: page_path(conn, :index)
  end

  def new_preference(conn, %{"id" => month_id}) do
    month = Crafters.Survey.get_month!(month_id)
            |> Poison.encode!()
    render conn, "preference.html", init: month
  end
end
