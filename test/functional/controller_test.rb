require 'test_helper'

class ControllerTest < ActionController::TestCase
  tests PostsController

  test 'availability of helpers & helper methods' do
    get :index, :format => :jam
    assert_response :success
  end
end
