require 'fluent/output'
require 'yajl/json_gem'

module Fluent
    class SplunkNovaOutput < Output
      # First, register the plugin. NAME is the name of this plugin
      # and identifies the plugin in the configuration file.
      Fluent::Plugin.register_output('splunknova', self)

      # Nova Splunk configuration parameters
      config_param :splunk_url,     :string,   :default => 'https://api.splunknova.com'
      config_param :splunk_token,   :string
      config_param :splunk_format,  :string,   :default => 'nova'
      config_param :splunk_url_path,  :string, :default => '/v1/events'


      # This method is called before starting.
      def configure(conf)
        super
        @splunk_full_url = @splunk_url + @splunk_url_path
        log.debug 'splunknova: sent data to ' + @splunk_full_url
      end

      # This method is called when starting.
      def start
        super
      end

      # This method is called when shutting down.
      def shutdown
        super
      end

      # This method is called when an event reaches Fluentd.
      # 'es' is a Fluent::EventStream object that includes multiple events.
      # You can use 'es.each {|time,record| ... }' to retrieve events.
      # 'chain' is an object that manages transactions. Call 'chain.next' at
      # appropriate points and rollback if it raises an exception.
      #
      # NOTE! This method is called by Fluentd's main thread so you should not write slow routine here. It causes Fluentd's performance degression.
      def emit(tag, es, chain)
        chain.next
        es.each {|time,record|
          log.info "OK!"
        }
      end
    end
  end