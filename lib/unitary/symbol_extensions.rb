module Unitary
  module SymbolExtensions
    def coerce number
      [
        Quantity.new(number, Dimension.new),
        Quantity.new(1     , to_dimension)
      ]
    end

    def to_dimension
      Dimension.new({self => 1})
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
