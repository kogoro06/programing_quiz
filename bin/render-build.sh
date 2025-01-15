set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:reset  # 一時的にリセットを実行
bundle exec rake db:migrate
bundle exec rake db:seed  # シードデータを投入