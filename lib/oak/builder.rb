module Oak
  class Builder
    def initialize(source, options={})
      @_source = source
      @_options = options
    end

    def render(scope, locals, &block)
      @_locals, @_scope = locals, scope
      self.copy_instance_variables_from(@_scope, [:@assigns, :@helpers])
#@_options[:scope] = @_scope
#@_options[:format] ||= self.request_format
#@_data = locals[:object] || self.default_object
#instance_eval(&block) if block_given?

      res = instance_eval(@_source) if @_source.present?
      res.to_json
    end

    def collection(obj, options={}, &block)
      obj.inject [] do |res, x|
        res << object(x, options, &block)
      end
    end

    def object(obj, options={}, &block)
      if ActiveRecord::Base.include_root_in_json
        root = options[:root] || obj.class.model_name.element
      end

      result = {}

      result.merge!(obj.as_json(options))

      if block
        result.merge! block.call(obj) unless root
        result[root].merge! block.call(obj) if root
      end

      result
    end

    protected

    # Returns a guess at the default object for this template
    # default_object => @user
    def default_object
      @_scope.respond_to?(:controller) ?
        instance_variable_get("@#{@_scope.controller.controller_name}") :
        nil
    end

    # Returns the request parameters if available in the scope
    # request_params => { :foo => "bar" }
    def request_params
      @_scope.respond_to?(:params) ? @_scope.params : {}
    end

    # Returns a guess at the format in this scope
    # request_format => "xml"
    def request_format
      format = self.request_params.has_key?(:format) ? @_scope.params[:format] : nil
      if request = @_scope.respond_to?(:request) && @_scope.request
        format ||= request.format.to_sym.to_s if request.respond_to?(:format)
      end
      format && self.respond_to?("to_#{format}") ? format : "json"
    end

    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name, object.instance_variable_get(name)) }
    end
  end
end
