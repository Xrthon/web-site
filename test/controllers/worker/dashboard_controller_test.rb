require "test_helper"

class Worker::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get worker_dashboard_show_url
    assert_response :success
  end
end
