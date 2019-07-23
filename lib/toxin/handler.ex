defmodule Toxin.Handler do
  def handle(req) do
    {_, list} = :application.get_key(:toxin, :modules)
    
    list =
      list
      |> Enum.filter(&(&1 |> Module.split() |> Enum.take(1) == ~w|API|))
      |> Enum.map(fn module ->
        {module, module.__info__(:functions)}
      end)

    find_path_module(list, req)
  end

  def find_path_module([{module, module_fns} | rest_modules], req) do
    val = find_path_functions(module, module_fns, req)

    case val do
      :not_found ->
        find_path_module(rest_modules, req)

      _ ->
        val
    end
  end

  def find_path_module([], _), do: Poison.encode!(%{error_code: 404, message: "NOT FOUND"})

  def find_path_functions(module, [{func, _} | rest_funcs], req) do
    try do
      apply(module, func, [req["method"], req["path"], req])
    rescue
      _ -> find_path_functions(module, rest_funcs, req)
    end
  end

  def find_path_functions(_, [], _), do: :not_found
end
