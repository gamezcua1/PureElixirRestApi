defmodule Toxin.Server do
  require Logger

  def start(port) do
    :gen_tcp.listen(port, [:binary, packet: 0,
                            active: false, reuseaddr: true])
    |> loop_server(port)
  end

  defp loop_server({:error, reason}, port) do
    case reason do
      :eaddrinuse -> Logger.error "🤯 Port #{port} already in use"
    end
  end

  defp loop_server({:ok, socket}, port) do
    Logger.info "🎧   Listenning on port #{port}"
    loop_server(socket)
  end

  defp loop_server(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Server.TaskSupervisor, fn -> serve({:ok, client}) end)
    ok = :gen_tcp.controlling_process(client, pid)
    loop_server(socket)
  end

  defp serve({:error, _client}) do
    Logger.error "🤯   A problem with the server has occurred"
  end

  defp serve({:ok, client}) do
    client
    |> read_line
    |> Toxin.Request.parse
    |> Toxin.Handler.handle
    |> Toxin.Response.parse
    |> write_line(client)
  end

  defp read_line(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, data} ->
        {:ok, data}
      _ -> :error
    end
  end

  defp write_line(:error, _) do
    Logger.error "[ERR] The Client has gone"
    Process.exit self(), :kill
  end

  defp write_line(data, client) do
    :gen_tcp.send(client, data)
    :gen_tcp.close(client)
  end

end
