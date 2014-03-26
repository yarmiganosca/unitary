require 'unitary/quantity'
require 'unitary/dimension'

class Symbol
  def coerce n
    [
      Unitary::Quantity.new(n, Unitary::Dimension[]),
      Unitary::Quantity.new(1, to_dimension)
    ]
  end

  def to_dimension
    Unitary::Dimension[self, 1]
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
