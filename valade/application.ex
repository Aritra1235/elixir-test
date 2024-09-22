defmodule Valade.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ValadeWeb.Telemetry,
      Valade.Repo,
      {DNSCluster, query: Application.get_env(:valade, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Valade.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Valade.Finch},
      # Start a worker by calling: Valade.Worker.start_link(arg)
      # {Valade.Worker, arg},
      # Start to serve requests, typically the last entry
      ValadeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Valade.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ValadeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
