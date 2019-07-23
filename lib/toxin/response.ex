defmodule Toxin.Response do
  def get do
    "HTTP/1.1 200 OK\n" <>
      "Content-Type: application/json; charset=utf-8\n" <>
      "Connection: Closed\n" <>
      "\n<html><body><h1>Hello, World!</h1></body></html>"
  end

  def parse(res) do
    "HTTP/1.1 200 OK\n" <>
      "Content-Type: application/json; charset=utf-8\n" <>
      "Connection: Closed\n" <>
      "\n#{res}"
  end

end
