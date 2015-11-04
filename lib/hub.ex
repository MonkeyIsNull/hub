defmodule Hub do
  def start do
    pid = spawn(__MODULE__, :connector, [[]])
    :global.register_name(:hub, pid)
  end

  def connect(pid, name) do
    send :global.whereis_name(:hub), {:new_client, pid, name}
  end

  def status(msg) do
    send :global.whereis_name(:hub), {:status, msg}
  end

  def secret(name, msg) do
    send :global.whereis_name(name), {:secret, msg}
  end

  def notify_clients(clients, pid, name) do
    Enum.each clients, fn client ->
      send client, {:new_client, pid, name}
    end
  end

  def send_status(clients, msg) do
    Enum.each clients, fn client ->
      send client, {:status, msg}
    end
  end

  def connector(clients) do
    receive do
      {:new_client, pid, name } -> 
        IO.puts "New client here: #{name} "
        notify_clients([pid | clients], pid, name)
        connector([pid | clients])
      {:status, msg} ->
        IO.puts "Sending out status message"
        send_status(clients, msg)
        connector(clients)
      {:quit}  ->
        IO.puts "Got quit, shutting down"
      garbage ->
        IO.puts "Got garbage:"
        IO.inspect garbage
        connector(clients)
    end
  end
end
