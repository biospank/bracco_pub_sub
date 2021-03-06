defmodule BraccoPubSub.ReleaseTasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:bracco_pub_sub)
    path = Application.get_env(:bracco_pub_sub, :migration_dir) || Application.app_dir(:bracco_pub_sub, "priv/repo/migrations")
    Ecto.Migrator.run(BraccoPubSub.Repo, path, :up, all: true)
  end
end
