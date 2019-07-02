defmodule Toxin.Request do
  require Logger 
  
  def parse({:error, _}) do
    :error
  end

  def parse({:ok, request}) do
    Logger.debug request
    String.split(request, "\r\n\r\n")
    |> parse_data

    {:ok, Toxin.Response.get}
  end

  defp parse_data([headers, data]) do
    [base |headers] = String.split(headers, "\r\n")
    [method, path, http_version] = String.split(base)
    req = %{"method" => :"#{method}", "path" => path, "http-version" => http_version }

    req = add_header(headers, req)

    IO.inspect req
  end

  defp add_header([header |rest_headers], req) do
    [key, value] = String.downcase(header) |> String.split(": ")
    add_header(rest_headers, Map.put(req, "#{key}", value))
  end

  defp add_header([], req), do: req

end