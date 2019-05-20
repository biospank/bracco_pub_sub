defmodule BraccoPubSub.HubTest do
  use BraccoPubSub.DataCase, async: false

  alias BraccoPubSub.Factory

  alias BraccoPubSub.{
    Listener,
    Hub,
    Utils
  }

  describe "match/3 publisher `tickets_changed` event" do
    setup do
      event = "tickets_changed"

      Listener.subscribe(event)

      publisher = Factory.create_account()
      subscriber = Factory.create_account()

      {:ok, publisher: publisher, subscriber: subscriber, event: event}
    end

    test "publisher does not receive notifications on tickets being created by himself",
      %{publisher: publisher, event: event} do

      Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, publisher.id, record)
    end

    test "publisher does not receive notifications on tickets being created by himself and updated by himself",
      %{publisher: publisher, event: event} do
      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: publisher.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      # IO.inspect(notification)

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, publisher.id, record)
    end

    test "publisher receive notifications on tickets created by himself and updated by others",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: subscriber.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:ok, :match} = Hub.match(event, publisher.id, record)
    end
  end

  describe "match/3 subscriber `tickets_changed` event" do
    setup do
      event = "tickets_changed"

      Listener.subscribe(event)

      publisher = Factory.create_account()
      subscriber = Factory.create_account()

      {:ok, publisher: publisher, subscriber: subscriber, event: event}
    end

    test "subscriber does not receive notifications on tickets updated by himself even if interested",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: subscriber.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, subscriber.id, record)
    end

    test "subscriber receive notifications on tickets he is interested",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: publisher.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:ok, :match} = Hub.match(event, subscriber.id, record)
    end
  end

  describe "match/3 publisher `comments_changed` event" do
    setup do
      event = "comments_changed"

      Listener.subscribe(event)

      publisher = Factory.create_account()
      subscriber = Factory.create_account()

      {:ok, publisher: publisher, subscriber: subscriber, event: event}
    end

    test "publisher does not receive notifications on ticket's comment being created by himself",
      %{publisher: publisher, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      Factory.create_comment(
        ticket_id: ticket.id,
        account_id: publisher.id
      )

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, publisher.id, record)
    end

    test "publisher does not receive notifications on ticket's comments being created by himself and updated by himself",
      %{publisher: publisher, event: event} do
      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      comment = Factory.create_comment(
        ticket_id: ticket.id,
        account_id: publisher.id
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(comment, updated_by: publisher.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, publisher.id, record)
    end

    test "publisher receive notifications on ticket's comments created by himself and updated by others",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      comment = Factory.create_comment(
        ticket_id: ticket.id,
        account_id: publisher.id
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      comment = Factory.update(comment, account_id: subscriber.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        _data
      }

      assert {:ok, :match} = Hub.match(event, publisher.id, ticket, comment)
    end
  end

  describe "match/3 subscriber `comments_changed` event" do
    setup do
      event = "comments_changed"

      Listener.subscribe(event)

      publisher = Factory.create_account()
      subscriber = Factory.create_account()

      {:ok, publisher: publisher, subscriber: subscriber, event: event}
    end

    test "subscriber does not receive notifications on ticket's comment updated by himself even if interested",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      comment = Factory.create_comment(
        ticket_id: ticket.id,
        account_id: publisher.id
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      comment = Factory.update(comment, account_id: subscriber.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        _data
      }

      assert {:error, :no_match} = Hub.match(event, subscriber.id, ticket, comment)
    end

    test "subscriber receive notifications on ticket's comments he is interested",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_ticket(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: [subscriber.id]
      )

      comment = Factory.create_comment(
        ticket_id: ticket.id,
        account_id: publisher.id
      )

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        _data
      }

      assert {:ok, :match} = Hub.match(event, subscriber.id, ticket, comment)
    end
  end

  describe "match/3 publisher `documents_changed` event" do
    setup do
      event = "documents_changed"

      Listener.subscribe(event)

      publisher = Factory.create_account()
      subscriber = Factory.create_account()

      {:ok, publisher: publisher, subscriber: subscriber, event: event}
    end

    test "publisher does not receive notifications on documents being created by himself",
      %{publisher: publisher, event: event} do

      Factory.create_document(
        created_by: publisher.id,
        updated_by: publisher.id
      )

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, publisher.id, record)
    end

    test "publisher does not receive notifications on documents being created by himself and updated by himself",
      %{publisher: publisher, event: event} do
      ticket = Factory.create_document(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: publisher.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      # IO.inspect(notification)

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, publisher.id, record)
    end

    test "publisher receive notifications on documents created by himself and updated by others",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_document(
        created_by: publisher.id,
        updated_by: publisher.id,
        assignees_id: []
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: subscriber.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:ok, :match} = Hub.match(event, publisher.id, record)
    end
  end

  describe "match/3 subscriber `documents_changed` event" do
    setup do
      event = "documents_changed"

      Listener.subscribe(event)

      publisher = Factory.create_account()
      subscriber = Factory.create_account()

      {:ok, publisher: publisher, subscriber: subscriber, event: event}
    end

    test "subscriber does not receive notifications on documents updated by himself even if interested",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_document(
        created_by: publisher.id,
        updated_by: publisher.id,
        share_with: [subscriber.id]
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: subscriber.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:error, :no_match} = Hub.match(event, subscriber.id, record)
    end

    test "subscriber receive notifications on documents he is interested",
      %{publisher: publisher, subscriber: subscriber, event: event} do

      ticket = Factory.create_document(
        created_by: publisher.id,
        updated_by: publisher.id,
        share_with: [subscriber.id]
      )

      assert_received {:notification, _pid, _ref, ^event, _data}

      Factory.update(ticket, updated_by: publisher.id)

      assert_received {
        :notification,
        _pid,
        _ref,
        ^event,
        payload
      }

      {:ok, record} = Utils.get_payload_record(payload)

      assert {:ok, :match} = Hub.match(event, subscriber.id, record)
    end
  end
end
