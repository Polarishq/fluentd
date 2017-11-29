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

## config: splunk_url

The Splunk URL

## config: splunk_format

Then Splunk format (nova default)


##config: splunk_token

The Splunk token (YOUR BASE64 ENCODED API KEYS)

##config: splunk_url_path

The Splunk entry point (/services/collector/event by default)




