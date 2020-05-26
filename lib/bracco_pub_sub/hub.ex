defmodule BraccoPubSub.Hub do
  def match("tickets_changed", listener, %{created_by: creator, updated_by: updater}) when creator != listener and updater != listener do
    {:ok, :match}
  end
  def match("tickets_changed", listener, %{created_by: listener, updated_by: updater}) when updater != listener do
    {:ok, :match}
  end
  def match("tickets_changed", listener, %{updated_by: updater, assignees_id: assignees}) when updater != listener do
    case listener in assignees do
      true -> {:ok, :match}
      false -> {:error, :no_match}
    end
  end
  def match("documents_changed", listener, %{created_by: creator, updated_by: updater}) when creator != listener and updater != listener do
    {:ok, :match}
  end
  def match("documents_changed", listener, %{created_by: listener, updated_by: updater}) when updater != listener do
    {:ok, :match}
  end
  def match("documents_changed", listener, %{updated_by: updater, share_with: share_with}) when updater != listener do
    case listener in share_with do
      true -> {:ok, :match}
      false -> {:error, :no_match}
    end
  end
  def match(_, _, _), do: {:error, :no_match}

  def match("comments_changed", listener, %{created_by: creator}, %{account_id: updater}) when creator != listener and updater != listener do
    {:ok, :match}
  end
  def match("comments_changed", listener, %{created_by: listener}, %{account_id: updater}) when updater != listener do
    {:ok, :match}
  end
  def match("comments_changed", listener, %{assignees_id: assignees}, %{account_id: updater}) when updater != listener do
    case listener in assignees do
      true -> {:ok, :match}
      false -> {:error, :no_match}
    end
  end
  def match("messages_changed", listener, %{actor_ids: actors}, %{created_by: creator}) when creator != listener do
    case listener in actors do
      true -> {:ok, :match}
      false -> {:error, :no_match}
    end
  end
  def match(_, _, _, _), do: {:error, :no_match}
end
