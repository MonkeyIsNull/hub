defmodule Client do

  def start(name) do
    pid = spawn(__MODULE__, :msg, [])
    IO.puts "Registering as #{name}"
    :global.register_name(name, pid)
    Hub.connect(pid)
  end

  def start do
    pid = spawn(__MODULE__, :msg, [])
    Hub.connect(pid)
  end

  def msg do
    receive do
      {:new_client, pid} ->
        IO.puts "I got a message that #{inspect pid} connected"
        msg
      {:status, mesg} ->
        IO.puts "HUB WARNING!!!! #{mesg} HUB WARNING!!!!!!"
        msg
      {:secret, mesg} ->
        IO.puts "[secret] #{mesg}"
        msg
      _ ->
        IO.puts "Got garbage, retry"
        msg
    end
  end
end

