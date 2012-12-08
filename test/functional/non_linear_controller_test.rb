require 'test_helper'

class NonLinearControllerTest < ActionController::TestCase
  test "should get solve" do
    get :solve
    assert_response :success
  end

end
