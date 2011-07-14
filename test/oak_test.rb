require 'test_helper'

class OakBuilderTest < ActiveSupport::TestCase
  test "" do
    assert_kind_of Module, Oak
  end

  setup do
    @post = Post.new :title => 'Hi!', :body => 'Sample text!'
    @builder = Oak::Builder.new
  end

  test 'instance should respond to object' do
    assert @builder.respond_to? :object
  end

  test 'basic test' do
    post = @post

    res = @builder.instance_eval do
      object post
    end

    assert_equal ({"created_at"=>nil, "body"=>"Sample text!", "title"=>"Hi!", "updated_at"=>nil}), res


    res = @builder.instance_eval do
      object post, :only => [:title, :body]
    end

    assert_equal ({"body"=>"Sample text!", "title"=>"Hi!"}), res
  end
end
