require "test_helper"

class EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get email_verifications_show_url
    assert_response :success
  end
end
