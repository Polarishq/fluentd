require 'helper'
require 'webmock/test_unit'


class SplunkNovaOutputTest < Test::Unit::TestCase
    SPLUNK_URL = 'https://api-bbourbie.splunknovadev.com:443'
    SPLUNK_TOKEN = 'QlA0YjdYcTJFVURGTkJaVGNUbURNT0pOSWJ2MzU4R1A6aHptUWFLT0JreWVTVjZyV3ZkdXdzWlhkVzBEdzgycDMxLVZDOTNkZG5ncDN2T1ZNaTY2bmN3NXdzak1LcGpWSg=='
    SPLUNK_FORMAT = 'nova'
    SPLUNK_URL_PATH = '/v1/events'

    SPLUNK_FULL_URL = "#{SPLUNK_URL}#{SPLUNK_URL_PATH}"

    ### for Splunk HEC
    CONFIG = %[
      splunk_url #{SPLUNK_URL}
      splunk_token #{SPLUNK_TOKEN}
      splunk_format #{SPLUNK_FORMAT}
      splunk_url_path #{SPLUNK_URL_PATH}
    ]

    def create_driver_slunknova(conf = CONFIG)
        Fluent::Test::OutputTestDriver.new(Fluent::SplunkNovaOutput).configure(conf)
    end


    def setup
        Fluent::Test.setup
        require 'fluent/plugin/out_splunknova'
        stub_request(:any, SPLUNK_FULL_URL)
      end

    def test_should_configure_splunknova
        d = create_driver_slunknova
        assert_equal SPLUNK_URL, d.instance.splunk_url
        assert_equal SPLUNK_TOKEN, d.instance.splunk_token
        assert_equal SPLUNK_FORMAT, d.instance.splunk_format
        assert_equal SPLUNK_URL_PATH, d.instance.splunk_url_path
      end

    def test_should_require_mandatory_parameter_token
        assert_raise Fluent::ConfigError do
            create_driver_slunknova(%[])
        end
      end

    def test_should_post_formatted_event_to_splunknova
        splunk_request = stub_request(:post, SPLUNK_FULL_URL)
        sourcetype = 'log'
        time = 123456
        record = "Message to send"
        d = create_driver_slunknova(CONFIG + %[sourcetype #{sourcetype}])
        d.run do
          d.emit(record, time)
        end
        assert_requested(splunk_request)
      end

end