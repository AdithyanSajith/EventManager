require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get host" do
    get dashboards_host_url
    assert_response :success
  end

  test "should get participant" do
    get dashboards_participant_url
    assert_response :success
  end
end
