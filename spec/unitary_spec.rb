require_relative 'spec_helper'

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
    it "simplify" do
      (5 * (:mi / :hr)).dimension.must_equal({mi: 1, hr: -1})
      ((5 * (:mi / :hr)) * (3 * :hr)).must_equal (15 * :mi)

      ((10 * :mi) / (2 * :hr)).must_equal (5 * (:mi / :hr))

      (5 * :mi * :mi).must_equal (5 * :mi ** 2)
    end

    it "should be associative" do
      (5 * :mi / :hr).must_equal (5 * (:mi / :hr))
    end
  end

  describe "exponentiation" do
    it "distributes across multiplication" do
      (8 * (:m ** 3)).must_equal ((2 * :m) ** 3)
    end
  end
end
