defmodule GpioTest.LedTest do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    pid = self()
    Ui.Endpoint.subscribe("led:channel")
    {:ok, led} = Gpio.start_link(4, :output)
    {:ok, {pid, led}}
  end

  def handle_info(%{event: "led:on"}, {_, led} = state) do
    Gpio.write(led, 1)
    {:noreply, state}
  end

  def handle_info(%{event: "led:off"}, {_, led} = state) do
    Gpio.write(led, 0)
    {:noreply, state}
  end
end