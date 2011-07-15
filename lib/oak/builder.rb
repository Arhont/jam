module Oak
  class Builder
    def initialize(source, options={})
      @_source = source
      @_options = options
    end

    def render(scope, locals, &block)
      @_locals, @_scope = locals, scope
      self.copy_instance_variables_from(@_scope, [:@assigns, :@helpers])

      instance_eval(@_source) if @_source.present?
    end

    def collection(obj, options={}, &block)
      obj.inject [] do |res, x|
        res << object(x, options, &block)
      end
    end

    def object(obj, options={}, &block)
      if ActiveRecord::Base.include_root_in_json
        root = options[:root] || obj.class.model_name.element.to_sym
      end

      result = {}

      result.merge!(obj.as_json(options).symbolize_keys)

      if block
        result.merge! block.call(obj) unless root
        result[root].merge! block.call(obj) if root
      end

      result[root].symbolize_keys! if root
      result
    end

    protected

    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name, object.instance_variable_get(name)) }
    end
  end
end
