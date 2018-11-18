defmodule BraccoPubSub.Listener do
  def subscribe(events_name) when is_list(events_name) do
    refs =
      events_name
      |> Enum.map(&subscribe/1)
      |> Enum.into([], fn {_, ref} -> ref end)

    {:ok, refs}
  end
  def subscribe(event_name) do
    Postgrex.Notifications.listen(notifier(), event_name)
  end

  def unsubscribe(refs) when is_list(refs) do
    refs
    |> Enum.map(&unsubscribe/1)
  end
  def unsubscribe(ref) do
    Postgrex.Notifications.unlisten(notifier(), ref)
  end

  defp notifier() do
    Process.whereis(:notifier)
  end
end
