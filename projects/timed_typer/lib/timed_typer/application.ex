defmodule TimedTyper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: TimedTyper.Worker.start_link(arg)
      # {TimedTyper.Play, []},
      %{
        id: :timer,
        start: {TimedTyper.Timer, :start_link, [[time: 2000]]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimedTyper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
