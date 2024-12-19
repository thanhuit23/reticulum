defmodule RetWeb.ErrorController do
  use RetWeb, :controller
  import Ecto.Query

  def notfound(conn, _params) do
    send_resp(conn, 404, "not found")
  end
end

