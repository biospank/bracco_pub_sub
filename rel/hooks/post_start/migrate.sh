echo "Running migrations..."
sleep 5
bin/bracco_pub_sub rpc "Elixir.BraccoPubSub.ReleaseTasks.migrate"
echo "Migrations run successfully"
