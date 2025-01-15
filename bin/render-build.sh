set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
echo "Running database migrations..."
bundle exec rake db:migrate
echo "Running database seed..."
bundle exec rake db:seed  # シードデータを投入