require 'helper'
require 'webmock/test_unit'


class SplunkNovaOutputTest < Test::Unit::TestCase
    SPLUNK_URL = 'https://api-bbourbie.splunknova.com'
    SPLUNK_TOKEN = 'YlU3ak9sTGRFYXI1VldhNG5abHhDNFNPRVFqMzZrSVg6dkVJb2RVNU0tQm54Y013TFdKc244d0V4bmlRVVl1V2xBdTBlXzRHYVY3cjZic3VOR2w3Wkdrb0ZKWXNVdTRHdg=='
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
        Fluent::Test::BufferedOutputTestDriver.new(Fluent::SplunkNovaOutput).configure(conf)
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

end