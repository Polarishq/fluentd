require 'fluent/output'
require 'yajl/json_gem'

module Fluent
    class SplunkNovaOutput < BufferedOutput
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

    # This method is called when an event reaches to Fluentd.
    # Convert the event to a raw string.
    def format(tag, time, record)
        [tag, time, record].to_msgpack
      end


    # This method is called every flush interval. Write the buffer chunk
    # to files or databases here.
    # 'chunk' is a buffer chunk that includes multiple formatted
    # events. You can use 'data = chunk.read' to get all events and
    # 'chunk.open {|io| ... }' to get IO objects.
    #
    # NOTE! This method is called by internal thread, not Fluentd's main thread. So IO wait doesn't affect other plugins.
    def write(chunk)
        data = chunk.read
        print data
      end
    end

    class SplunkNovaOutputError < StandardError
        def initialize(message, status_code, invalid_event_number, http_status_code)
          super("#{message} (http status code #{http_status_code}, status code #{status_code}, invalid event number #{invalid_event_number})")
        end
      end

  end