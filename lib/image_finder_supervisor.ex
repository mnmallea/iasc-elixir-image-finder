defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(_init_arg) do
    children = [
      ImageFinder.Worker,
      ImageFinder.DownloaderSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
