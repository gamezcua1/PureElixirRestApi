defmodule API.Books do
  alias Models.Book, as: Book

  def get_all("GET", "/books/", req) do
    res = Book.get_all() |> Poison.encode!()
  end

  def create("POST", "/books/", req) do
    do_save(req)
  end

  def create("PUT", "/books/" <> key, req) do
    do_save(req)
  end

  def do_save(req) do
    data = %{
      name: req["body"]["name"],
      year: req["body"]["year"],
      author: req["body"]["author"]
    }

    with {_, :ok} <- Book.save(data) do
      Poison.encode!(data)
    else
      _ ->
        Poison.encode!(%{error_code: 500, message: "An error has ocurred"})
    end
  end

  def delete("DELETE", "/books/" <> key, req) do
    key =
      key
      |> String.split("%20")
      |> Enum.join(" ")
      |> Book.delete

    Poison.encode!(%{ message: "DELETED Sucessfully"})
  end
end
