defmodule Valade.Repo do
  use Ecto.Repo,
    otp_app: :valade,
    adapter: Ecto.Adapters.Postgres
end
