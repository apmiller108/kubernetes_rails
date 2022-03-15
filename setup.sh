# Usage:
#   docker run --rm -it -v "$PWD":/app -w /app ruby:3.0 sh setup.sh

# Install dependencies
gem install rails

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg

echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

apt-get update
apt-get install nodejs yarn -y

# Setup rails app
rails new kubetest --database=postgresql

cd kubetest
mv * .*  ../
cd ..
rmdir kubetest

bin/rails webpacker:install

bundle add sidekiq

# Configure database
DBCONFIG=$(cat <<EOF
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV['POSTGRES_HOST'] %>
  user: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
development:
  <<: *default
  database: kubetest_development
test:
  <<: *default
  database: kubetest_test
production:
  <<: *default
  database: kubetest_production
  username: kubetest
  password: <%= ENV['SUPER_SECRET_DATABASE_PASSWORD'] %>
EOF
)
echo "$DBCONFIG" > config/database.yml

# Add env vars for development
touch .env
echo "POSTGRES_DB=kubetest_development" >> .env
echo "POSTGRES_USER=postgres" >> .env
echo "POSTGRES_PASSWORD=postgres" >> .env
echo "POSTGRES_HOST=database" >> .env
echo "REDIS_URL=redis://redis:6379/1" >> .env
