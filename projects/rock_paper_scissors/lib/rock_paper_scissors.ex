defmodule RockPaperScissors do
  use GenServer

  def start_link(opts) do
    IO.puts("RockPaperScissors Started")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # GenServer Callback Functions

  @impl true
  def init(state) do
    send(self(), :prompt)
    {:ok, state}
  end

  @impl true
  def handle_info(:prompt, state) do
    choice = "Please enter rock, paper, or scissors. \n"
      |> IO.gets()
      |> String.trim()
      |> String.downcase()

    answer = Enum.random(["rock", "paper", "scissors"])

    # Case intentionally does not validate choice so the
    # Supervisor can restart the app on a crash
    result =
      case {choice, answer} do
        {"rock", "scissors"} -> "You Win!"
        {"paper", "rock"} -> "You Win!"
        {"scissors", "paper"} -> "You Win!"
        {"rock", "paper"} -> "You Lose!"
        {"paper", "scissors"} -> "You Lose!"
        {"scissors", "rock"} -> "You Lose!"
        {same, same} -> "Draw!"
      end

    IO.puts(result)

    send(self(), :prompt)
    {:noreply, state}
  end
end
