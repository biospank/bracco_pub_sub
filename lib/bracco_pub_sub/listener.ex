defmodule BraccoPubSub.Listener do
  def subscribe(event_name) do
    Postgrex.Notifications.listen(notifier(), event_name)
  end

  def unsubscribe(ref) do
    Postgrex.Notifications.unlisten(notifier(), ref)
  end

  defp notifier() do
    Process.whereis(:notifier)
  end
end
