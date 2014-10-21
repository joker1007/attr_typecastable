require 'spec_helper'

describe AttrTypecastable do
  class Money
    include AttrTypecastable
    typed_attr_accessor :value, Integer

    def initialize(value)
      self.value = value
    end

    def ==(other)
      return false unless other.is_a?(Money)

      @value == other.value
    end
  end

  class CastToMoney < AttrTypecastable::Types::Base
    private

    def do_typecast(value)
      return value if value.is_a?(Money)

      if value.is_a?(Integer)
        Money.new(value)
      else
        raise AttrTypecastable::Types::CastError, "Cannot convert to Money"
      end
    end
  end

  class User
    include AttrTypecastable

    typed_attr_accessor :name, String
    typed_attr_accessor :default_name, String, default: "Foo"
    typed_attr_accessor :conditional_default, String, default: proc { |user|
      user.conditional_default = "Hello #{user.name}"
    }
    typed_attr_accessor :not_nil_name, String, allow_nil: false, default: ""
    typed_attr_accessor :birthday, "Date"
    typed_attr_accessor :birthday_time, Time
    typed_attr_accessor :birthday_datetime, DateTime
    typed_attr_accessor :age, Integer
    typed_attr_accessor :bmi, Float
    typed_attr_accessor :bmi_r, Rational
    typed_attr_accessor :property, CastToMoney
    typed_attr_accessor :debt, BigDecimal
    typed_attr_accessor :debt_with_precision, BigDecimal, precision: 3
    typed_attr_accessor :debt_with_fig, BigDecimal, fig: 5
    typed_attr_accessor :adult, Boolean
    typed_attr_accessor :admin, Boolean, true_value: ["yes"]
    typed_attr_accessor :active, Boolean, true_value: [/true/i]
    typed_attr_accessor :manager, Boolean, allow_nil: false, default: false
    typed_attr_accessor :raw_value, nil, default: 1
    typed_attr_accessor :raw_value2, Object
    typed_attr_accessor :raw_value3, default: "raw_value3"

    def initialize(name: nil, default_name: nil)
      self.name = name
      self.default_name = default_name
    end
  end

  describe ".typed_attr_accessor" do
    it "defines attribute_accessor with typecasting" do
      user = User.new

      assert { user.default_name == "Foo" }

      user.name = "joker"
      assert { user.name == "joker" }

      user.name = 10
      assert { user.name == "10" }

      user.name = nil
      assert { user.name.nil? }

      assert { user.not_nil_name == "" }

      user.not_nil_name = nil
      assert { user.not_nil_name == "" }

      user.not_nil_name = "joker"
      assert { user.not_nil_name == "joker" }

      user.age = 5
      assert { user.age == 5 }

      user.age = "unknown"
      assert { user.age == 0 }

      user.birthday = "2012-10-01"
      assert { user.birthday == Date.new(2012, 10, 1) }

      user.birthday = Date.new(2012, 10, 2)
      assert { user.birthday == Date.new(2012, 10, 2) }

      user.birthday_time = "2012-10-01 10:00:00"
      assert { user.birthday_time == Time.new(2012, 10, 1, 10) }

      user.birthday_datetime = "2012-10-01 10:00:00"
      assert { user.birthday_datetime.is_a?(DateTime) }
      assert { user.birthday_datetime == Time.new(2012, 10, 1, 10) }

      user.birthday_datetime = Time.new(2012, 10, 2, 2)
      assert { user.birthday_datetime.is_a?(DateTime) }
      assert { user.birthday_datetime == Time.new(2012, 10, 2, 2) }

      user.bmi = "20.1"
      assert { user.bmi > 20.09 && user.bmi < 20.11 }

      user.bmi = "20.1"
      assert { user.bmi == "20.1".to_r }

      user.property = 10000
      assert { user.property == Money.new(10000) }

      user.debt = 10000
      assert { user.debt == BigDecimal.new("10000") }
      user.debt = Rational(10000, 1)
      assert { user.debt == BigDecimal.new("10000") }
      user.debt = 10000.11
      assert { user.debt == BigDecimal.new("10000.11") }
      user.debt = "10000.12"
      assert { user.debt == BigDecimal.new("10000.12") }

      user.debt_with_precision = 1.3333333333
      assert { user.debt_with_precision == BigDecimal.new("1.33") }

      user.debt_with_fig = Rational("1000.11")
      assert { user.debt_with_fig == BigDecimal.new("1000.1") }

      user.adult = "true"
      assert { user.adult == true }

      user.adult = "other"
      assert { user.adult == true }

      user.adult = "false"
      assert { user.adult == false }

      user.adult = 1
      assert { user.adult == true }

      user.adult = 0
      assert { user.adult == false }

      user.admin = "yes"
      assert { user.admin == true }

      user.admin = false
      assert { user.admin == false }

      user.active = "tRUe"
      assert { user.active == true }

      assert { user.manager == false }

      user.manager = "true"
      assert { user.manager == true }

      user.default_name = "Changed"
      user.reset_default_name!
      assert { user.default_name == "Foo" }

      assert { user.raw_value == 1 }
      user.raw_value = "raw"
      assert { user.raw_value == "raw" }

      user.raw_value2 = "raw_value2"
      assert { user.raw_value2 == "raw_value2" }

      assert { user.raw_value3 == "raw_value3" }
      user.raw_value3 = 3.0
      assert { user.raw_value3 > 2.9 }

      user2 = User.new(name: 20)
      assert { user2.name == "20" }
      assert { user2.default_name == "Foo" }
      assert { user2.conditional_default == "Hello 20" }

      user3 = User.new(default_name: "kakyoin")
      assert { user3.name.nil? }
      assert { user3.default_name == "kakyoin" }
    end
  end
end
