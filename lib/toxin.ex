defmodule Toxin do
  use Application

  def start() do
    children = [
      {Task.Supervisor, name: Server.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Toxin.Server.start(4040) end}, restart: :permanent),
    ]

    opts = [strategy: :one_for_one, name: Toxin.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
