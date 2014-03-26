module Unitary
  class Dimension < Hash
    def coerce n
      [
        Quantity.new(n, self.class[]),
        Quantity.new(1, self)
      ]
    end

    def self.[] *args
      super(*args).without_zeros
    end

    def without_zeros
      reject { |k, v| v == 0 }
    end

    def [] key
      super(key) || 0
    end

    def * dim
      case dim
      when Symbol
        merge self.class[dim, 1]
      when self.class
        merge dim
      else
        dim * self
      end
    end

    def / dim
      self * (dim ** -1)
    end

    def ** n
      self.class[
        keys.zip(values.map { |exp| exp * n })
      ]
    end

    def merge dim
      self.class[self + dim]
    end

    def + dim
      (keys + dim.keys).uniq.map do |key|
        [key, self[key] + dim[key]]
      end
    end
  end
end
