module Unitary
  class Dimension
    attr_reader :exponents_by_unit

    def initialize(exponents_by_unit = {})
      @exponents_by_unit = exponents_by_unit
    end

    def exponent_for_unit(unit)
      exponents_by_unit[unit] || 0
    end

    def units
      exponents_by_unit.keys
    end

    def coerce number
      [
        Quantity.new(number, self.class.new),
        Quantity.new(1     , self)
      ]
    end

    def == dimension
      dimension.is_a?(self.class) &&
        exponents_by_unit == dimension.exponents_by_unit
    end

    def * dimension
      case dimension
      when self.class
        multiply_by_dimension(dimension)
      when Symbol
        multiply_by_unit(dimension)
      else
        dimension * self
      end
    end

    def / dimension
      self * (dimension ** -1)
    end

    def ** exponent
      multiply_all_unit_exponents_by_number(exponent)
    end

    private

    def remove_zeroed_exponents
      exponents_by_unit.reject! { |unit, exponent| exponent == 0 }
    end

    def multiply_by_unit(unit)
      dimension_for_unit = Dimension.new({unit => 1})

      multiply_by_dimension(dimension_for_unit)
    end

    def multiply_by_dimension(dimension)
      units_in_either_dimension = (units + dimension.units).uniq

      units_in_either_dimension.each do |unit|
        exponents_by_unit[unit] = exponent_for_unit(unit) + dimension.exponent_for_unit(unit)
      end

      remove_zeroed_exponents

      self
    end

    def multiply_all_unit_exponents_by_number(number)
      exponents_by_unit.each do |unit, exponent|
        exponents_by_unit[unit] = exponent * number
      end

      self
    end

    def clone
      self.class.new(exponents_by_unit.clone)
    end
  end
end
