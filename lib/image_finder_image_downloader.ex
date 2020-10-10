defmodule ImageFinder.ImageDownloader do
  use Task, restart: :transient

  def start_link(init_arg) do
    Task.start_link(__MODULE__, :run, [init_arg])
  end

  def run({url, out_path}) do
    fetch_link(url, out_path)
  end

  defp fetch_link(link, target_directory) do
    HTTPotion.get(link).body |> save(target_directory)
  end

  defp digest(body) do
    :crypto.hash(:md5, body) |> Base.encode16()
  end

  defp save(body, directory) do
    File.write!("#{directory}/#{digest(body)}", body)
  end
end
