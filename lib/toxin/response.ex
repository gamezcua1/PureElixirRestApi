defmodule Toxin.Response do
  def get do
    "HTTP/1.1 200 OK\n" <>
      "Date: Mon, 27 Jul 2009 12:28:53 GMT\n" <>
      "Server: Elixir\n" <>
      "Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT\n" <>
      "Content-Type: text/html; charset=utf-8\n" <>
      "Connection: Closed\n" <>
      "\n<html><body><h1>Hello, World!</h1></body></html>"
  end

  def parse(res) do
    "HTTP/1.1 200 OK\n" <>
      "Date: Mon, 27 Jul 2009 12:28:53 GMT\n" <>
      "Server: Elixir\n" <>
      "Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT\n" <>
      "Content-Type: text/html; charset=utf-8\n" <>
      "Connection: Closed\n" <>
      "\n#{res}"
  end

end
