module Jam
  class Builder

    # Constructs a new engine based on given source and options
    #
    #   JamTemplate.new { 'object @post' }
    def initialize(source, options={})
      @_source = source
      @_options = options
    end

    # Renders the representation based on source, object, scope and locals
    #
    #   JamTemplate.new { 'object @post' }.render(@scope)
    def render(scope, locals, &block)
      @_locals, @_scope = locals, scope
      self.copy_instance_variables_from(@_scope, [:@assigns, :@helpers])

      instance_eval(@_source) if @_source.present?
    end

    # Returns an hash representation for each element in the collection
    # with options and passed block
    #
    #   collection @posts, :only => [:body] do |p|
    #     { :title => p.title.titleize }
    #   end
    def collection(obj, options={}, &block)
      obj.inject [] do |res, x|
        res << object(x, options, &block)
      end
    end

    # Returns an hash representation of the passed object
    # with options and passed block
    #
    #   object @post, :only => [:body] do |p|
    #     { :title => p.title.titleize }
    #   end
    def object(obj, options={}, &block)
      if ActiveRecord::Base.include_root_in_json
        root = options[:root] || obj.class.model_name.element
      end

      result = {}

      if block
        options[:only] ||= [:id]

        blk = block.call(obj).stringify_keys
        result.merge!(blk) unless root
        result[root] = blk if root
      end

      as_json_res = obj.as_json(options)

      if root
        result[root] ||= {}
        result[root].reverse_merge! as_json_res[root]
      else
        result.reverse_merge! as_json_res
      end

      result.stringify_keys
    end

    # Render template with variables passed in the hash
    #
    #   template ('posts/show', :@post => post)
    def template(file, vars={})
      source = self.fetch_source(file)
      vars.each do |k, v|
        @_scope.instance_variable_set k, v
      end
      Jam::Builder.new(source).render(@_scope, @_locals)
    end

    protected

    # Supports calling helpers defined for the template scope using method_missing hook
    def method_missing(name, *args, &block)
      @_scope.respond_to?(name) ? @_scope.send(name, *args, &block) : super
    end

    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name, object.instance_variable_get(name)) }
    end

    # Returns source for a given relative file
    #
    #   fetch_source("show", :view_path => "...") => "...contents..."
    def fetch_source(file, options={})
      root_path = Rails.root if defined?(Rails)
      view_path = options[:view_path] || File.join(root_path, "app/views/")
      file_path = Dir[File.join(view_path, file + "*.jam")].first
      File.read(file_path) if file_path
    end
  end
end
