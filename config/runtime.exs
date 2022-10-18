import Config
import Blog.ConfigHelpers

database_url = get_env("DATABASE_URL", "ecto://postgres:postgres@localhost/blog_#{config_env()}")

pool_size = get_env("POOL_SIZE", 10, :int)
maybe_ipv6 = if get_env("ECTO_IPV6", false, :bool), do: [:inet6], else: []

host = get_env("PHX_HOST", "example.com")
port = get_env("PORT", 4000, :int)

config :blog, Blog.Repo,
  url: database_url,
  pool_size: pool_size,
  socket_options: maybe_ipv6

case config_env() do
  :prod ->
    secret_key_base = get_env("SECRET_KEY_BASE")

    config :blog, BlogWeb.Endpoint,
      url: [host: host, port: 443, scheme: "https"],
      http: [
        ip: {0, 0, 0, 0, 0, 0, 0, 0},
        port: port
      ],
      secret_key_base: secret_key_base,
      server: get_env("PHX_SERVER", false, :bool)

  :dev ->
    nil

  :test ->
    config :blog, Blog.Repo, database: "#{database_url}#{get_env("MIX_TEST_PARTITION", "")}"
end
