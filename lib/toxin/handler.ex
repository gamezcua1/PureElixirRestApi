defmodule Toxin.Handler do
  def handle(req) do
    funcs = API.Books.__info__(:functions)

    {_, list} = :application.get_key(:toxin, :modules)
    IO.inspect list
    list =
      list
      |> Enum.filter(&(&1 |> Module.split() |> Enum.take(1) == ~w|API|))

    find_path_functions(funcs, req)
  end

  def find_path_module([module | rest_modules]) do
    find_path_module(rest_modules)
  end

  def find_path_functions([{func, _} | rest_funcs], req) do
    try do
      apply(API.Books, func, [req["method"], req["path"], req])
    rescue
      value -> find_path_functions(rest_funcs, req)
    end
  end

  def find_path_functions([], req), do: Poison.encode!(%{error_code: 404, message: "NOT FOUND"})
end
