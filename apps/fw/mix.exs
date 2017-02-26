defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :fw,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],

     deps_path: "../../deps/#{@target}",
     build_path: "../../_build/#{@target}",
     config_path: "../../config/config.exs",
     lockfile: "../../mix.lock",

     kernel_modules: kernel_modules(@target, Mix.env),

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(Mix.env),
     deps: deps() ++ system(@target, Mix.env)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Fw, []}, applications: applications(Mix.env)]
  end

  defp applications(:prod), do: [:nerves_interim_wifi, :elixir_ale] ++ general_apps()
  defp applications(_), do: general_apps()

  defp general_apps, do: [:logger, :runtime_tools, :ui]

  def deps do
    [
      {:nerves, "~> 0.4"},
      {:nerves_interim_wifi, "~> 0.1.1", only: :prod},
      {:dummy_nerves, in_umbrella: true, only: [:dev, :test]},
      {:ui, in_umbrella: true},
      {:elixir_ale, "~> 0.5.7", only: :prod}
    ]
  end

  def system(target, :prod) do
    [
      {:"nerves_system_#{target}", "~> 0.6"},
    ]
  end
  def system(_, _), do: []

  def kernel_modules("rpi3", :prod) do
    ["brcmfmac"]
  end
  def kernel_modules(_, _), do: []

  def aliases(:prod) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
  def aliases(_), do: []

end
