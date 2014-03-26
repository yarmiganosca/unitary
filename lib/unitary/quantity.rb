require 'unitary/dimension'

module Unitary
  class Quantity
    attr_reader :size, :dimension

    def initialize size, dimension
      @size      = size
      @dimension = dimension
    end

    def == q
      [:size, :dimension].map do |sym|
        q.respond_to?(sym) && self.send(sym) == q.send(sym)
      end.all?
    end

    def * q
      if q.respond_to?(:size) && q.respond_to?(:dimension)
        self.class.new(size * q.size, dimension * q.dimension)
      else
        case q
        when Numeric
          self.class.new(size * q, dimension)
        when Symbol, Hash
          self.class.new(size, dimension * q)
        end
      end
    end

    def / q
      self * (q ** -1)
    end

    def ** n
      self.class.new(size ** n, dimension ** n)
    end

    def + q
      raise "not compatible" unless q.dimension == dimension

      self.class.new(size + q.size, dimension)
    end

    def coerce n
      [
        Quantity.new(n, Dimension[]),
        self
      ]
    end
  end
end
