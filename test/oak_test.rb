require 'test_helper'

class OakBuilderTest < ActiveSupport::TestCase
  test "" do
    assert_kind_of Module, Oak
  end

  setup do
    @post  = Post.new :title => 'Hi!', :body => 'Sample text!'
    @post2 = Post.new :title => 'Hi 2!', :body => 'Sample text!'
    @posts = [@post, @post2]
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
  end

  test 'test with root' do
    ActiveRecord::Base.include_root_in_json = true
    post = @post
    res = @builder.instance_eval do
      object post, :only => [:title, :body]
    end

    assert_equal ({'post' => {"body"=>"Sample text!", "title"=>"Hi!"}}), res
  end

  test 'test with block' do
    ActiveRecord::Base.include_root_in_json = false
    post = @post

    res = @builder.instance_eval do
      object post, :only => [:title] do |x|
        {
          :body => x.body.downcase
        }
      end
    end

    assert_equal ({:body=>"sample text!", "title"=>"Hi!"}), res
  end

  test 'test with block and root' do
    ActiveRecord::Base.include_root_in_json = true
    post = @post

    res = @builder.instance_eval do
      object post, :only => [:title] do |x|
        {
          'body' => x.body.downcase
        }
      end
    end

    assert_equal ({ 'post' => {'body'=>"sample text!", "title"=>"Hi!"}}), res
  end

  test 'test with block and renamed root' do
    ActiveRecord::Base.include_root_in_json = true
    post = @post

    res = @builder.instance_eval do
      object post, :only => [:title], :root => 'bost' do |x|
        {
          'body' => x.body.downcase
        }
      end
    end

    assert_equal ({ 'bost' => {'body'=>"sample text!", "title"=>"Hi!"}}), res
  end

  test 'test collection' do
    ActiveRecord::Base.include_root_in_json = false
    posts = @posts

    res = @builder.instance_eval do
      collection posts, :only => [:title, :body]
    end

    assert_equal ([{ 'body'=>"Sample text!", "title"=>"Hi!"}, {'body' => 'Sample text!', 'title' => 'Hi 2!'}]), res
  end
end
