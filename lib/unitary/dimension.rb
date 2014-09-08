module Unitary
  class Dimension
    def initialize(exponents_by_unit = {})
      @exponents_by_unit = exponents_by_unit
    end
    attr_reader :exponents_by_unit

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
      exponents_by_unit == dimension.exponents_by_unit
    end

    def remove_zeroed_exponents
      exponents_by_unit.reject! { |unit, exponent| exponent == 0 }
    end

    def exponent_for_unit(unit)
      exponents_by_unit[unit] || 0
    end

    def * dimension
      case dimension
      when Symbol
        multiply_by_unit(dimension)
      when self.class
        multiply_by_dimension(dimension)
      else
        dimension * self
      end
    end

    def multiply_by_unit(unit)
      multiply_by_dimension(Dimension.new({unit => 1}))
    end

    def multiply_by_dimension(dimension)
      unique_units = (units + dimension.units).uniq

      unique_units.each do |unit|
        exponents_by_unit[unit] = exponent_for_unit(unit) + dimension.exponent_for_unit(unit)
      end

      remove_zeroed_exponents

      self
    end

    def / dimension
      self * (dimension ** -1)
    end

    def ** exponent
      multiply_all_unit_exponents_by_number(exponent)
    end

    def multiply_all_unit_exponents_by_number(number)
      exponents_by_unit.each do |unit, exponent|
        exponents_by_unit[unit] = exponent * number
      end

      self
    end

    def + dimension
      unique_units = (units + dimension.units).uniq

      unique_units.map do |unit|
        [unit, exponent_for_unit(unit) + dimension.exponent_for_unit(unit)]
      end
    end

    private

    def clone
      self.class.new(exponents_by_unit.clone)
    end
  end
end
