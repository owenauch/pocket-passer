require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get auth" do
    get auth_auth_url
    assert_response :success
  end

end
