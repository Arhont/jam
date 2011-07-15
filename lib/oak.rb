module Oak
  class Builder
    def collection(obj, options={})
      obj.inject [] do |res, x|
        res << yield(x)
      end
    end

    def object(obj, options={})
      result = {}

      result.merge!(obj.as_json(options))

      if block_given?
        result.merge! yield(obj)
      end

      result
    end
  end
end
