defmodule TimedTyper.Timer do
  use GenServer

  @maxtime 5000
  # TODO: use an argument to set this.

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    time = Keyword.get(opts, :time, 2000)
    timer = Process.send_after(self(), :expire, time)

    Process.send_after(self(), :restart, 1000)

    IO.inspect(timer, label: "New Timer")
    {:ok, [timer: timer, max_time: time]}
  end

  @impl true
  def handle_info(:expire, state) do
    timer = Keyword.get(state, :timer)
    IO.inspect(timer, label: "Expired")
    # IO.puts("Time's up")
    # send(self(), :restart)
    {:noreply, state}
  end

  @impl true
  def handle_info(:restart, state) do
    timer = Keyword.get(state, :timer)
    :timer.cancel(timer)
    IO.inspect(timer, label: "Canceled")

    max_time = Keyword.get(state, :max_time)
    Process.send_after(self(), :expire, max_time)
    new_timer = Process.send_after(self(), :expire, max_time * 2)
    # {:ok, %{timer: timer}}
    {:noreply, [timer: new_timer, max_time: max_time]}
  end
end
