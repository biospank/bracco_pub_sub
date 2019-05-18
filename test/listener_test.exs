defmodule BraccoPubSub.ListenerTest do
  use BraccoPubSub.DataCase, async: false

  import BraccoPubSub.Factory

  alias BraccoPubSub.Listener

  describe "Ticket notification listener" do
    setup do
      publisher = create_account()
      subscriber = create_account()

      {:ok, publisher: publisher, subscriber: subscriber}
    end

    test "unattached subscriber process does not receive `tickets_changed` notifications",
      %{publisher: publisher, subscriber: subscriber} do

      create_ticket(
        created_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      refute_received {}
    end

    test "attached subscribe process receive `tickets_changed` notifications",
      %{publisher: publisher, subscriber: subscriber} do

      Listener.subscribe("tickets_changed")

      create_ticket(
        created_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      assert_received {:notification, _pid, _ref, "tickets_changed", _data}
    end
  end

  describe "Comment notification listener" do
    setup do
      publisher = create_account()
      subscriber = create_account()

      {:ok, publisher: publisher, subscriber: subscriber}
    end

    test "unattached subscriber process does not receive `tickets_changed` notifications",
      %{publisher: publisher, subscriber: subscriber} do

      ticket = create_ticket(
        created_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      create_comment(
        ticket_id: ticket.id,
        account_id: subscriber.id
      )

      refute_received {}
    end

    test "attached subscriber process receive `comments_changed` notifications",
      %{publisher: publisher, subscriber: subscriber} do

      Listener.subscribe("comments_changed")

      ticket = create_ticket(
        created_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      create_comment(
        ticket_id: ticket.id,
        account_id: subscriber.id
      )

      assert_received {:notification, _pid, _ref, "comments_changed", _data}
    end
  end
end
