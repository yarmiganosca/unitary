require 'minitest/autorun'
require 'minitest/mock'

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
        Unitary::Quantity.new(n, Unitary::Dimension[]),
        self
      ]
    end
  end

  class Dimension < Hash
    def coerce n
      [
        Unitary::Quantity.new(n, self.class[]),
        Unitary::Quantity.new(1, self)
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

describe Unitary do
  describe "Symbol coercion" do
    it "gets multiplication right" do
      (4.67 * :mg).size.must_equal 4.67
      (3 * :kg).dimension.must_equal({kg: 1})
    end
  end

  describe "Dimension" do
    it "initializes" do
      dim = Unitary::Dimension[:kw, 1, :hr, 1] * :hr
      dim.must_equal({kw: 1, hr: 2})
    end

    describe "division" do
      it "makes the exponents negative" do
        (:mi / :hr).must_equal({mi: 1, hr: -1})
      end

      it "removes cancelled out exponents" do
        (:hr * (:mi / :hr)).must_equal({mi: 1})
      end

      it "handles entirely negative dimensions" do
        (1 / :hr).dimension.must_equal({hr: -1})
      end
    end

    describe "exponentiation" do
      it "multiplies the exponents" do
        ((2 * :m) ** 3).dimension.must_equal({m: 3})
      end
    end

    describe "mutliplication" do
      it "should handle numerics" do
        ((:mi / :hr) * 5).must_equal (5 * :mi / :hr)
      end
    end
  end

  describe "equality" do
    it "considers two quantities equal if they share size and units" do
      (4.3 * :kg).must_equal (4.3 * :kg)
    end

    it "doesn't consider a quantity and its size equal" do
      (4.3 * :kg).wont_equal 4.3
    end
  end

  describe "scalar multiplication" do
    it "is calculated correctly for Quantity * Numeric" do
      ((4 * :kg) * 4).must_equal (16 * :kg)
      (4 * (4 * :kg)).must_equal (16 * :kg)

      ((4 * :kg) * 1.1).size.must_equal 4.4
    end
  end

  describe "quantity addition" do
    it "combines quantities with like units" do
      ((4 * :kg) + (5.3 * :kg)).must_equal (9.3 * :kg)
    end
  end

  describe "compound quantities" do
    it "should work" do
      (5 * (:mi / :hr)).dimension.must_equal({mi: 1, hr: -1})
      ((5 * (:mi / :hr)) * (3 * :hr)).must_equal (15 * :mi)

      ((10 * :mi) / (2 * :hr)).must_equal (5 * (:mi / :hr))

      (5 * :mi * :mi).must_equal (5 * :mi ** 2)
    end

    it "should be associative" do
      (5 * :mi / :hr).must_equal (5 * (:mi / :hr))
    end
  end

  describe "volume" do
    it "should work" do
      (8 * (:m ** 3)).must_equal ((2 * :m) ** 3)
    end
  end
end
