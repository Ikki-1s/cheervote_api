#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# WARNING: createとseedはfargateの初回のみ実行
# WARNING: タスクを個々に作って実行のほうがいいかも
# bundle exec bin/rails db:create
bundle exec bin/rails db:migrate
# bundle exec bin/rails db:seed_fu

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
