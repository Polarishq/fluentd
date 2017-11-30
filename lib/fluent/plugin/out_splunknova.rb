require 'fluent/output'
require 'yajl/json_gem'
#require 'net/http'

module Fluent
    class SplunkNovaOutput < BufferedOutput
      # First, register the plugin. NAME is the name of this plugin
      # and identifies the plugin in the configuration file.
      Fluent::Plugin.register_output('splunknova', self)

      # Nova Splunk configuration parameters
      config_param :splunk_url,       :string,   :default => 'https://api.splunknova.com'
      config_param :splunk_token,     :string
      config_param :splunk_format,    :string,   :default => 'nova'
      config_param :splunk_url_path,  :string,   :default => '/v1/events'

      # Splunk event parameters
      config_param :index,               :string,  :default => 'main'
      config_param :event_host,          :string,  :default => nil
      config_param :source,              :string,  :default => 'fluentd'
      config_param :sourcetype,          :string,  :default => 'tag'

      # This method is called before starting.
      def configure(conf)
        super
        @splunk_full_url = @splunk_url + @splunk_url_path
        log.debug 'splunknova: sent data to ' + @splunk_full_url
        if conf['event_host'] == nil
            begin
              @event_host = `hostname`.delete!("\n")
            rescue
              @event_host = 'unknown'
            end
          end
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
    # Loop through all records and sent them to Splunk
    def write(chunk)
        chunk.msgpack_each {|(tag,time,record)|
          sourcetype = @sourcetype == 'tag' ? tag : @sourcetype
          body = {}
          body["time"] = time.to_s
          body["entity"] = record
          body["sourcetype"] = sourcetype
          body["source"] = @source
          body["index"] = @index
          body["host"] = @event_host
          send_to_novasplunk(body.to_json)
        }
      end


    def send_to_novasplunk(body)
        log.debug "splunknova: " + body + "\n"
        uri = URI(@splunk_full_url)
        # Create client
        http = Net::HTTP.new(uri.host, uri.port)

        # Create Request
        req = Net::HTTP::Post.new(uri)
        # Add headers
        req.add_field "Authorization", "Splunk #{@splunk_token}"
        # Add headers
        req.add_field "Content-Type", "application/json"
        req.add_field "Accept", "application/json"
        # Set body
        req.body = body
        # Handle SSL

        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        # Fetch Request
        res = http.request(req)
        log.debug "splunkhec: response HTTP Status Code is #{res.code}"
        if res.code.to_i != 200
          body = JSON.parse(res.body)
          raise SplunkNovaOutputError.new(body['text'], body['code'], body['invalid-event-number'], res.code)
        end
      end
    end

    class SplunkNovaOutputError < StandardError
        def initialize(message, status_code, invalid_event_number, http_status_code)
          super("#{message} (http status code #{http_status_code}, status code #{status_code}, invalid event number #{invalid_event_number})")
        end
      end
  end