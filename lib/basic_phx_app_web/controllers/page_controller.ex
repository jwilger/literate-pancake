defmodule BasicPhxAppWeb.PageController do
  use BasicPhxAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
