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

    def do_typecast
      return @value if @value.is_a?(Money)

      if @value.is_a?(Integer)
        Money.new(@value)
      else
        raise AttrTypecastable::Types::CastError, "Cannot convert to Money"
      end
    end
  end

  class User
    include AttrTypecastable

    typed_attr_accessor :name, String
    typed_attr_accessor :default_name, String, default: "Foo"
    typed_attr_accessor :not_nil_name, String, allow_nil: false, default: ""
    typed_attr_accessor :birthday, Date
    typed_attr_accessor :birthday_time, Time
    typed_attr_accessor :birthday_datetime, DateTime
    typed_attr_accessor :age, Integer
    typed_attr_accessor :bmi, Float
    typed_attr_accessor :property, CastToMoney

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
      assert { user.birthday_datetime == Time.new(2012, 10, 1, 10) }

      user.bmi = "20.1"
      assert { user.bmi > 20.09 && user.bmi < 20.11 }

      user.property = 10000
      assert { user.property == Money.new(10000) }

      user2 = User.new(name: 20)
      assert { user2.name == "20" }
      assert { user2.default_name == "Foo" }

      user3 = User.new(default_name: "kakyoin")
      assert { user3.name.nil? }
      assert { user3.default_name == "kakyoin" }
    end
  end
end
