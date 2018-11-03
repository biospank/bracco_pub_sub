defmodule BraccoPubSub.Listener do
  def subscribe(event_name) do
    pid = notifier()
    Postgrex.Notifications.listen(pid, event_name)
  end

  def unsubscribe(ref) do
    pid = notifier()
    Postgrex.Notifications.unlisten(pid, ref)
  end

  defp notifier() do
    Process.whereis(:notifier)
  end
end
