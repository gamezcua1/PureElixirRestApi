defmodule Toxin.Request do
  require Logger 
  
  def parse({:error, _}), do: :error

  def parse({:ok, request}) do
    req = String.split(request, "\r\n\r\n")
          |> parse_headers
          |> parse_data
          |> parse_body

    IO.inspect req
    {:ok, Toxin.Response.get}
  end

  defp parse_headers([headers, data]) do
    [base |headers] = String.split(headers, "\r\n")
    [method, path, http_version] = String.split(base)
    req = %{"method" => :"#{method}", "path" => path, "http-version" => http_version }
          |>add_header(headers)

    [req, data]
  end

  defp add_header(req, [header |rest_headers]) do
    [key, value] = String.downcase(header) |> String.split(": ")
    add_header(Map.put(req, "#{key}", value), rest_headers)
  end

  defp add_header(req, []), do: req

  defp parse_data([req, data]) do
    params = get_params(req)
    [Map.put(req, "params", params), data]
  end

  defp get_params(req) do
    [_, params] = String.split(req["path"], "?") 
    URI.decode_query(params)
  end

  defp parse_body([req, data]), do: Map.put(req, "body", Jason.decode!(data))

end