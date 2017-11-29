# fluentd splunknova plugin

The plugin is to be installed with fluentd in order to send events to Splunk HEC or Splunk Nova.


#How to install on Os

Please, install the following commands.

```
brew install ruby
gem install bundler
```



# How to run tests.

```
$ bundle install --path vendor/bundle # Install related libraries.
$ bundle exec rake test
```