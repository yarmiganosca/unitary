require 'unitary/dimension'

module Unitary
  class Quantity
    attr_reader :size, :dimension

    def initialize size, dimension
      @size      = size
      @dimension = dimension
    end

    def == quantity
      quantity.is_a?(self.class) &&
        size      == quantity.size &&
        dimension == quantity.dimension
    end

    def * quantity
      case quantity
      when Quantity
        self.class.new(size * quantity.size, dimension * quantity.dimension)
      when Numeric
        self.class.new(size * quantity, dimension)
      when Symbol, Dimension
        self.class.new(size, dimension * quantity)
      end
    end

    def / quantity
      self * (quantity ** -1)
    end

    def ** exponent
      self.class.new(size ** exponent, dimension ** exponent)
    end

    def + quantity
      raise "not compatible" unless quantity.dimension == dimension

      self.class.new(size + quantity.size, dimension)
    end

    def coerce number
      [
        Quantity.new(number, Dimension.new),
        self
      ]
    end
  end
end
