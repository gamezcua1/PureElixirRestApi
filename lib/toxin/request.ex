defmodule Toxin.Request do
  def parse({:error, _}), do: :error

  def parse({:ok, request}) do
    String.split(request, "\r\n\r\n")
    |> parse_headers
    |> parse_data
    |> parse_body
  end

  defp parse_headers([headers, data]) do
    [base | headers] = String.split(headers, "\r\n")
    [method, path, http_version] = String.split(base)
    [path | params] = String.split(path, "?")

    req =
      %{
        "method" => method,
        "path" => path,
        "params" => params,
        "http-version" => http_version
      }
      |> add_header(headers)

    [req, data]
  end

  defp add_header(req, [header | rest_headers]) do
    [key, value] = String.downcase(header) |> String.split(": ")
    add_header(Map.put(req, "#{key}", value), rest_headers)
  end

  defp add_header(req, []), do: req

  defp parse_data([req, data]) do
    params = get_params(req["params"])
    [Map.put(req, "params", params), data]
  end

  defp get_params([]), do: %{}

  defp get_params([headers]) do
    URI.decode_query(headers)
  end

  defp parse_body([req, data]) when data != "", do: Map.put(req, "body", Jason.decode!(data))
  defp parse_body([req, _data]), do: req

end
