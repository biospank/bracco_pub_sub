defmodule BraccoPubSub.Repo.Migrations.AdminSetup do
  use Ecto.Migration

  def change do
    execute """
      insert into accounts (firstname, lastname, email, psw, confirm_psw, profile,
        nickname, status, avatar_color, online, deleted)
      values ('Ilaria', 'Di Rosa', 'dirosa.ilaria@gmail.com',
        '21232f297a57a5a743894a0e4a801fc3', '21232f297a57a5a743894a0e4a801fc3',
        0, 'administrator', 1, '#f09a9a', false, false);
    """

    execute """
      insert into profile_settings (account_id, tickets_notifications)
        values (1, true);
    """
  end
end
