require 'unitary/dimension'

module Unitary
  class Quantity
    attr_reader :size, :dimension

    def initialize size, dimension
      @size      = size
      @dimension = dimension
    end

    def == quantity
      [:size, :dimension].map do |sym|
        quantity.respond_to?(sym) && self.send(sym) == quantity.send(sym)
      end.all?
    end

    def * quantity
      if quantity.respond_to?(:size) && quantity.respond_to?(:dimension)
        self.class.new(size * quantity.size, dimension * quantity.dimension)
      else
        case quantity
        when Numeric
          self.class.new(size * quantity, dimension)
        when Symbol, Dimension
          self.class.new(size, dimension * quantity)
        end
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
