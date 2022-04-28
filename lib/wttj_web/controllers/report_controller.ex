# Just here to silence DIalyzer warning.
defmodule WttjWeb.ReportController do
  use WttjWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 204, "")
  end
end
