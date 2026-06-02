require "test_helper"

class IdentityVerificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get identity_verifications_show_url
    assert_response :success
  end

  test "should get new" do
    get identity_verifications_new_url
    assert_response :success
  end

  test "should get create" do
    get identity_verifications_create_url
    assert_response :success
  end
end
