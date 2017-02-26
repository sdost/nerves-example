defmodule Ui.API.LedController do
  use Ui.Web, :controller

  require Logger

  def update_led(conn, %{"state" => state}) do

    Logger.debug("update_led:#{state}")

    if state == "on" do
        Ui.Endpoint.broadcast("led:channel", "led:on", %{})
    else
        Ui.Endpoint.broadcast("led:channel", "led:off", %{})
    end

    conn |> put_status(200) |> json(%{"state" => state})
  end
end