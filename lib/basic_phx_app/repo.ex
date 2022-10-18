defmodule BasicPhxApp.Repo do
  use Ecto.Repo,
    otp_app: :basic_phx_app,
    adapter: Ecto.Adapters.Postgres
end
