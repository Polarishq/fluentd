PLUGIN_NAME=splunknova/fluentd


build_image:
	docker build -t ${PLUGIN_NAME}:latest docker_images/docker_image

push: raketest build_image
	docker push ${PLUGIN_NAME}:latest

installgem:
	gem install bundler
	ls -lrt
	bundle install --path vendor/bundle

raketest: installgem
	bundle exec rake test
