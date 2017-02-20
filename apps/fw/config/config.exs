use Mix.Config

config :fw, :wlan0,
  ssid: "sam",
  key_mgmt: :"WPA-PSK",
  psk: "Pine2069Nut"

config :logger, level: :debug
