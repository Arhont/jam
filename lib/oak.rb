module Oak
  class Builder
    def collection(obj, options={}, &block)
      obj.inject [] do |res, x|
        res << object(obj, options, block)
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
  end
end
