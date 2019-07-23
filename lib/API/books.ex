defmodule API.Books do
  alias Models.Book, as: Book

  def get_all("GET", "/books/", req) do
    res = Book.get_all() |> Poison.encode!()
  end

  def create("POST", "/books/", req) do
    data = %{
      name: req["body"]["name"],
      year: req["body"]["year"],
      author: req["body"]["author"]
    }

    with {_, :ok} <- Book.create(data) do
      Poison.encode!(data)
    else
      err ->
        Poison.encode!(%{error_code: 500, message: "An error has ocurred"})
    end
  end
end
