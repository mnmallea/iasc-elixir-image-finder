defmodule ImageFinder.ImageDownloader do
  use Task, restart: :transient

  def start_link(init_arg) do
    IO.puts("Iniciando task desde #{inspect(self())}")
    Task.start_link(__MODULE__, :run, [init_arg])
  end

  def run({url, out_path}) do
    IO.puts("Iniciando task #{url} #{inspect(self())}")
    fetch_link(url, out_path)
    IO.puts("Finalizando task #{url} #{inspect(self())}")
  end

  defp fetch_link(link, target_directory) do
    import HTTPotion, only: [get: 1]
    case get(link) do
      %{ body: body } -> save(body, target_directory)
      _ -> raise "Error en la request: #{inspect(self())}"
    end
  end

  defp digest(body) do
    :crypto.hash(:md5, body) |> Base.encode16()
  end

  defp save(body, directory) do
    IO.puts 'Imagen descargada'
    File.write!("#{directory}/#{digest(body)}", body)
  end
end
