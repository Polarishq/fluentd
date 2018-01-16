



install:
	gem install bundler
	bundle install --path vendor/bundle

test:
	bundle exec rake test