init:
	docker-compose build
	docker-compose run --rm web bundle install
	docker-compose run --rm web bundle exec rails db:reset

b:
	docker-compose build

# update gems
bundle:
	docker-compose run --rm web bundle

# Current is get error `Faker not found`
pinit:
	docker-compose run --rm web bundle exec rails db:reset
	docker-compose run --rm web bundle exec rails assets:precompile

migrate:
	docker-compose run --rm web bundle exec rails db:migrate

migrate-test:
	docker-compose run --rm -e RAILS_ENV=test web bundle exec rails db:migrate

dbreset:
	docker-compose run --rm web bundle exec rails db:reset

up:
	docker-compose up

upd:
	docker-compose up -d

upb:
	docker-compose up --build

upbd:
	docker-compose up --build -d

stop:
	docker-compose stop

down:
	docker-compose down

# restart
rs:
	docker-compose stop
	docker-compose up -d

ps:
	docker ps
	docker-compose ps

# remove logs
rml:
	rm -f web/log/*.log

# remove caches
rmc:
	rm -rf web/tmp/cache/*

# generate ERD (require: graphviz)
erd:
	rm -f web/erd.*
	docker-compose run --rm web bundle exec rails erd filetype='dot'
	dot -Tpdf web/erd.dot -o web/erd.pdf

# run tests for local
# INFO: Running `nginx -t` will be failed when `web` doesn't serve application
#       Before run `nginx -t`, should run server with `docker-compose up -d`
# TODO: Find elegant solution...
tests:
	docker-compose up -d
	docker-compose run --rm nginx nginx -t
	docker-compose run --rm unbound unbound-checkconf
	docker-compose run --rm web bundle exec rspec
	docker-compose stop

rspec:
	docker-compose run --rm web bundle exec rspec

rspec-model:
	docker-compose run --rm web bundle exec rails spec:models

rspec-reqs:
	docker-compose run --rm web bundle exec rails spec:requests

# rails routes
routes:
	docker-compose run --rm web bundle exec rails routes

# rails stats
stats:
	docker-compose run --rm web bundle exec rails stats

# rails console --sandbox
console:
	docker-compose run --rm web bundle exec rails c --sandbox
