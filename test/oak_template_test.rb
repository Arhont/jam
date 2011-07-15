require 'test_helper'

class OakTemplateTest < ActiveSupport::TestCase

  setup do
    @post = Post.new(:title => 'Hi', :body => 'Hello world!')
    @json = OakTemplate.new { |x| 'object(@post, :only => [:title]) { |y| { "title" => y.title.downcase} }' }
  end

  test 'instance should respond to object' do
    assert_equal ::Tilt['test.oak'], OakTemplate
  end

end
