PLUGIN_NAME=splunknova/fluentd


build_image:
	docker build -t ${PLUGIN_NAME}:latest docker_images/docker_image

push: build_image
	docker push ${PLUGIN_NAME}:latest

install:
	gem install bundler
	bundle install --path vendor/bundle

raketest:
	bundle exec rake test