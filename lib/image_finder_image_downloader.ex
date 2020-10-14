defmodule ImageFinder.ImageDownloader do
  use GenServer, restart: :transient

  def start_link(init_arg) do
    IO.puts("Iniciando task desde #{inspect(self())}")
    GenServer.start_link(__MODULE__, init_arg)
  end

  @impl true
  def init({ url, out_path }) do
    GenServer.cast(self(), :fetch_link)
    {:ok, { url, out_path, 1 }}
  end

  @impl true
  def handle_cast(:fetch_link, { url, out_path, retry_count }) do
    case HTTPotion.get(url) do
      %HTTPotion.Response{ status_code: 200, body: body } -> 
        IO.puts "Request completada"
        save(body, out_path)
        { :stop, :normal, {} }
      %HTTPotion.Response{ status_code: 404 } ->
        IO.puts "Imagen no encontrada"
        { :stop, :normal, {} }
      _ when retry_count > 3 ->
        IO.puts "Error en la request. Fin del woker"
        { :stop, :normal, {} }
      _ ->
        IO.puts "Error en la request. Intento #{retry_count}"
        Process.sleep(retry_count * 1_000)
        GenServer.cast(self(), :fetch_link)
        { :noreply, { url, out_path, retry_count + 1 } }
    end
  end

  defp save(body, directory) do
    IO.puts 'Imagen descargada'
    File.write!("#{directory}/#{UUID.uuid4}", body)
  end
end
