module Oak
  class Builder
    def collection(obj, options={})
      obj.inject [] do |res, x|
        res << yield(x)
      end
    end

    def object(obj, options={})
      only    = options[:only]
      except  = options[:except]
      methods = options[:methods]
      root    = options[:root]

      result = {}

      if only
        result.merge!(Hash[only.map do |m|
          [m.to_s, obj.read_attribute(m)]
        end])
      elsif obj.respond_to? :attributes
        result.merge!(obj.attributes)
      end

      if methods
        result.merge!(Hash[methods.map do |m|
          [m, obj.send(m)]
        end])
      end

      if block_given?
        result.merge! yield(obj)
      end

      result
    end
  end
end
