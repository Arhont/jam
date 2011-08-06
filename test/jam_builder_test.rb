require 'test_helper'

class JamBuilderTest < ActiveSupport::TestCase
  test "" do
    assert_kind_of Module, Jam
  end

  setup do
    @post  = Post.new :title => 'Hi!', :body => 'Sample text!'
    @post2 = Post.new :title => 'Hi 2!', :body => 'Sample text!'
    @posts = [@post, @post2]
    @scope = Object.new
    @scope.instance_variable_set :@post, @post
    @scope.instance_variable_set :@posts, @posts
  end

  # Context object
  test 'basic test' do
    # If block not presented Jam generate all attributes
    t = JamTemplate.new { 'object @post' }
    assert_equal ({'created_at' => nil, 'body' => "Sample text!", 'title' => "Hi!", 'updated_at' => nil}), t.render(@scope)
  end

  test 'with block' do
    # If block presented Jam generate only attributes from block
    # and attributes setted in :only & :except keys
    t = JamTemplate.new { 'object(@post) {|x| {:comments_count => 23} }' }
    assert_equal ({'comments_count' => 23}), t.render(@scope)
  end

  test 'with root' do
    ActiveRecord::Base.include_root_in_json = true
    t = JamTemplate.new do
      'object @post, :only => [:title, :body]'
    end
    assert_equal ({'post' => {'body' => "Sample text!", 'title' => "Hi!"}}), t.render(@scope)
  end

  test 'with root and block' do
    ActiveRecord::Base.include_root_in_json = true
    template = JamTemplate.new do
      %q{
        object(@post, :only => [:title]) { |p|
          { :body => p.body.downcase }
        }
      }
    end
    assert_equal ({'post' => {'body' => "sample text!", 'title' => "Hi!"}}), template.render(@scope)
  end

  test 'with block and renamed root' do
    ActiveRecord::Base.include_root_in_json = true
    template = JamTemplate.new do
      %q{
        object(@post, :only => [:title], :root => :bost) { |x|
          { :body => x.body.downcase }
        }
      }
    end
    assert_equal ({'bost' => {'body' => "sample text!", 'title' => "Hi!"}}), template.render(@scope)
  end

  test 'collection' do
    ActiveRecord::Base.include_root_in_json = false
    template = JamTemplate.new do
      'collection @posts, :only => [:title, :body]'
    end
    assert_equal ([{'body' => "Sample text!", 'title' => "Hi!"}, {'body' => 'Sample text!', 'title' => 'Hi 2!'}]), template.render(@scope)
  end
end
