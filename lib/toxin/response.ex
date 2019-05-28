defmodule Toxin.Response do

  def get do
    "HTTP/1.1 200 OK\n" <>
    "Date: Mon, 27 Jul 2009 12:28:53 GMT\n" <>
    "Server: Apache/2.2.14 (Win32)\n" <>
    "Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT\n" <>
    "Content-Length: 88\n" <>
    "Content-Type: text/html\n" <>
    "Connection: Closed\n" <>
    "123"
  end

end