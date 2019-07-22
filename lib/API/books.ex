defmodule API.Books do
  def get_all("GET", "/books/", req), do: "GET all books"

  def create("POST", "/books/", req), do: "Saving a book"
end