export

DOCKER := docker compose

RUBY_VERSION := 3.3.0

ifeq ($(CI), true)
	APP_IMAGE := cimg/ruby:$(RUBY_VERSION)
else
	APP_IMAGE := ruby:$(RUBY_VERSION)
endif

up:
	$(DOCKER) up -d
	$(DOCKER) exec app bundle install
down:
	$(DOCKER) down
tty-app:
	$(DOCKER) exec app bash
tty-solr:
	$(DOCKER) exec solr bash
test:
	#$(DOCKER) exec app bundle exec rspec ./spec/relevance/name_initials_query_spec.rb
	$(DOCKER) exec app bundle exec rspec 
load-data:
	$(DOCKER) exec app load-data
reload-config:
	$(DOCKER) exec solr solr-configs-reset
ps:
	$(DOCKER) ps
zip:
	bash ./.circleci/build.sh
