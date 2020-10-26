require 'test_helper'

class FeedControllerTest < ActionDispatch::IntegrationTest
  test "should get read" do
    get feed_read_url
    assert_response :success
  end

end
