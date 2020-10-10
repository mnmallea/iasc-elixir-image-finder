defmodule ImageFinder.Worker do
  use GenServer

  def start_link(_name) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:fetch, source_file, target_directory}, _from, state) do
    content = File.read!(source_file)
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/

    Regex.scan(regexp, content)
    |> Enum.map(&List.first/1)
    |> Enum.map(&fetch_link(&1, target_directory))

    {:reply, :ok, state}
  end

  defp fetch_link(url, out_path) do
    ImageFinder.DownloaderSupervisor.start_finder(url, out_path)
  end
end
