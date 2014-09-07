module Unitary
  module SymbolExtensions
    def coerce n
      [
        Quantity.new(n, Dimension[]),
        Quantity.new(1, to_dimension)
      ]
    end

    def to_dimension
      Dimension[self, 1]
    end

    def * n
      to_dimension * n
    end

    def / n
      to_dimension / n
    end

    def ** n
      to_dimension ** n
    end
  end
end
