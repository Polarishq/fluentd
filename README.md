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

The Splunk URL.

## config: splunk_format

Then Splunk format (nova default) (not used yet)


##config: splunk_token

The Splunk token (YOUR BASE64 ENCODED API KEYS)

##config: splunk_url_path

The Splunk entry point (/services/collector/event by default)




##how to setup k8 fluentd nova daemonset plugin.

I would assume that the user knows how to setup a kubernetes server otherwise one can look at kubernetes tutorial with a minikube.
Also, it is necessary to have access to the docker hub repo polarishq/fluentd_splunknova.

The user just needs to edit the file [fluentd-daemonset-splunknova.yaml](k8_image/fluentd-daemonset-splunknova.yaml),
more precisely the following values which are suceptible to be changed.
```YAML
- name:  SPLUNK_URL
value: 'https://api-bbourbie.splunknovadev.com:443'
- name:  SPLUNK_TOKEN
value: "QlA0YjdYcTJFVURGTkJaVGNUbURNT0pOSWJ2MzU4R1A6aHptUWFLT0JreWVTVjZyV3ZkdXdzWlhkVzBEdzgycDMxLVZDOTNkZG5ncDN2T1ZNaTY2bmN3NXdzak1LcGpWSg=="
```

Then, you need to create the daemonset by running the command

```Bash
kubectl create -f fluentd-daemonset-splunknova.yaml
```

##how to create the image polarishq/fluentd_splunknova

```Bash
docker build -t polarishq/fluentd_splunknova k8_image/good_image
```