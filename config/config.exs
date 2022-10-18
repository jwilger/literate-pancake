import Config

config :basic_phx_app, ecto_repos: [BasicPhxApp.Repo]

config :basic_phx_app, BasicPhxAppWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BasicPhxAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BasicPhxApp.PubSub,
  live_view: [signing_salt: "BiLoaGaG"]

config :basic_phx_app, BasicPhxApp.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, :api_client, false

config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.1.8",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

case config_env() do
  :prod ->
    config :basic_phx_app, BasicPhxAppWeb.Endpoint,
      cache_static_manifest: "priv/static/cache_manifest.json"

    config :logger, level: :info

  :dev ->
    config :basic_phx_app, BasicPhxApp.Repo,
      stacktrace: true,
      show_sensitive_data_on_connection_error: true

    config :basic_phx_app, BasicPhxAppWeb.Endpoint,
      http: [ip: {127, 0, 0, 1}, port: 4000],
      check_origin: false,
      code_reloader: true,
      debug_errors: true,
      secret_key_base: "NYZcxIOUaUHcuLkDxyPrY7ti2InEHpA32riXr3K0CXOCTiQP5J0l82oWSYaLVhJu",
      watchers: [
        esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
        tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
      ],
      live_reload: [
        patterns: [
          ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
          ~r"priv/gettext/.*(po)$",
          ~r"lib/basic_phx_app_web/(live|views)/.*(ex)$",
          ~r"lib/basic_phx_app_web/templates/.*(eex)$"
        ]
      ]

    config :logger, :console, format: "[$level] $message\n"

    config :phoenix, :stacktrace_depth, 20

    config :phoenix, :plug_init_mode, :runtime

  :test ->
    config :basic_phx_app, BasicPhxAppWeb.Endpoint,
      http: [ip: {127, 0, 0, 1}, port: 4002],
      secret_key_base: "TnKiBnvKiZF7an2UoXNvG+yfyPXo8zvd0ryI2rqPGPs58Z3JWCwmw3DqzvexIzvZ",
      server: false

    config :basic_phx_app, BasicPhxApp.Repo, pool: Ecto.Adapters.SQL.Sandbox

    config :basic_phx_app, BasicPhxApp.Mailer, adapter: Swoosh.Adapters.Test

    config :logger, level: :warn

    config :phoenix, :plug_init_mode, :runtime
end
