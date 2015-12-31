default: install server

install:
	@gem install bundler --no-ri --no-rdoc
	@bundle install

server:
	@bundle exec rails server

test:
	@bundle exec rake test

bootstrap: install
	@bundle exec rake db:{drop,create,migrate,seed}

.PHONY: default install server test bootstrap
