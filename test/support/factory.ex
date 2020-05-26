defmodule BraccoPubSub.Factory do
  alias BraccoPubSub.Schemas.{
    Account,
    Ticket,
    Comment,
    Document,
    Chat,
    Message
  }
  alias BraccoPubSub.Repo

  # It sounds like your tests are using the SQL sandbox:
  # so the test would happen inside a transaction which gets rolled back at the end.
  # Since the transaction is never committed, the NOTIFY is not emitted either.

  def create_account(attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      %Account{
        firstname: "Test firstname",
        lastname: "Test firstname",
        email: "test@example.com",
        psw: "pWx",
        profile: 0,
        nickname: "Test",
        mobilephone: "",
        status: 1,
        avatar_color: "pink",
        online: false,
        deleted: false
      }
      |> Map.merge(Enum.into(attrs, %{}))
      |> Repo.insert!()
    end)
  end

  def create_ticket(attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      %Ticket{
        title: "Test title",
        description: "Test description",
        archived: false,
        status: 0,
        assignees_id: [],
        expire_at: Date.utc_today() |> Date.add(2),
        created_by: nil,
        created_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_by: nil,
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }
      |> Map.merge(Enum.into(attrs, %{}))
      |> Repo.insert!()
    end)
  end

  def create_comment(attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      %Comment{
        body_text: "Comment text",
        ticket_id: nil,
        account_id: nil,
        created_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }
      |> Map.merge(Enum.into(attrs, %{}))
      |> Repo.insert!()
    end)
  end

  def create_document(attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      %Document{
        title: "Test title",
        body_text: "Test description",
        archived: false,
        share_with: [],
        created_by: nil,
        created_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_by: nil,
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }
      |> Map.merge(Enum.into(attrs, %{}))
      |> Repo.insert!()
    end)
  end

  def update(struct, attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      struct
      |> Ecto.Changeset.change(
        Keyword.merge(
          attrs,
          updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.add(2) |> NaiveDateTime.truncate(:second)
        )
      )
      |> Repo.update!
    end)
  end

  def create_chat(attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      %Chat{
        uuid: UUID.uuid4(),
        name: "Test chat",
        actor_ids: [],
        created_by: nil,
        created_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      }
      |> Map.merge(Enum.into(attrs, %{}))
      |> Repo.insert!()
    end)
  end

  def create_message(attrs \\ []) do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(Repo, fn ->
      %Message{
        chat: nil,
        text: "Test message",
        created_by: nil,
        created_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      }
      |> Map.merge(Enum.into(attrs, %{}))
      |> Repo.insert!()
    end)
  end
end
