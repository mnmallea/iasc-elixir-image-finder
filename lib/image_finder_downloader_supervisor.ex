defmodule ImageFinder.DownloaderSupervisor do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_restarts: 1)
  end

  def start_finder(url, out_path) do
    DynamicSupervisor.start_child(__MODULE__, {ImageFinder.ImageDownloader, {url, out_path}})
  end
end
