require "test_helper"

class HostsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get hosts_dashboard_url
    assert_response :success
  end
end
