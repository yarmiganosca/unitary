module Unitary
  module SymbolExtensions
    def coerce number
      [
        Quantity.new(number, Dimension[]),
        Quantity.new(1     , to_dimension)
      ]
    end

    def to_dimension
      Dimension[self, 1]
    end

    def * number
      to_dimension * number
    end

    def / number
      to_dimension / number
    end

    def ** number
      to_dimension ** number
    end
  end
end
