defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(ImageFinder.Worker, [ImageFinder.Worker]),
      worker(ImageFinder.DownloaderSupervisor, [ImageFinder.DownloaderSupervisor])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
