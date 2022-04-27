# Just here to silence DIalyzer warning.
defmodule WttjWeb.StubController do
  use WttjWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 204, "")
  end
end
