defmodule ImageFinder.ImageDownloader do
  use GenServer

  def start_link(state) do
    IO.puts('Start link')
    { :ok, pid } = GenServer.start_link(__MODULE__, state)
    GenServer.cast(pid, {:perform})
  end
  
  @impl true
  def init({url, out_path}) do
    IO.puts('init')
    {:ok, {url, out_path}}    
  end

  @impl true
  def handle_cast({:perform}, { url, out_path }) do
    Process.sleep(3000)
    fetch_link(url, out_path)
    {:stop, :normal, {}}
  end

  def fetch_link(link, target_directory) do
    HTTPotion.get(link).body  |> save(target_directory)
  end

  def digest(body) do
    :crypto.hash(:md5 , body) |> Base.encode16()
  end

  def save(body, directory) do
    File.write! "#{directory}/#{digest(body)}", body
  end
end
