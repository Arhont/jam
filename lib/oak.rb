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

      if methods
        Hash[methods.map do |m|
          [m, obj.send(m)]
        end].merge(yield(obj))
      else
        yield(obj)
      end
    end
  end
end
