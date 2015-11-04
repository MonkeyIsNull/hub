defmodule Client do

  def start(name) do
    pid = spawn(__MODULE__, :msg, [])
    IO.puts "Registering as #{name}"
    :global.register_name(name, pid)
    Hub.connect(pid, name)
  end

  def start do
    pid = spawn(__MODULE__, :msg, [])
    Hub.connect(pid)
  end

  def chat(who, mesg) do
    send :global.whereis_name(who), {:chat, Node.self(), mesg}
  end

  def msg do
    receive do
      {:new_client, pid, name} ->
        IO.puts "#{name} connected"
        msg
      {:status, mesg} ->
        IO.puts "HUB WARNING!!!! #{mesg} HUB WARNING!!!!!!"
        msg
      {:secret, mesg} ->
        IO.puts "[secret] #{mesg}"
        msg
      {:chat, from, mesg} ->
        IO.puts "[#{from}] #{mesg}"
      _ ->
        IO.puts "Got garbage, retry"
        msg
    end
  end
end

