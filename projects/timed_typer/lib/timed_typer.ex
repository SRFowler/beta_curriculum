defmodule TimedTyper do
  use GenServer

  @word_list ["red", "green", "blue", "yellow", "orange"]
  @max_time_ms 5000

  def start_link(_opts \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    send(self(), :prompt)
    {:ok, state}
  end


  @impl true
  def handle_info(:prompt, state) do

    word = Enum.random(@word_list)

    answer = "Type #{word} and press ENTER/RETURN: \n"
      |> IO.gets()
      |> String.trim()

    case {word, answer} do
      {same, same} -> "You did it!"
      _ -> "You Lose!"
    end

    send(self(), :prompt)
    {:noreply, state}
  end
end
