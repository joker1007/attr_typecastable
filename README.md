# attr\_typecastable
[![Build Status](https://travis-ci.org/joker1007/attr_typecastable.svg?branch=master)](https://travis-ci.org/joker1007/attr_typecastable)
[![Coverage Status](https://coveralls.io/repos/joker1007/attr_typecastable/badge.png)](https://coveralls.io/r/joker1007/attr_typecastable)
[![Code Climate](https://codeclimate.com/github/joker1007/attr_typecastable/badges/gpa.svg)](https://codeclimate.com/github/joker1007/attr_typecastable)

attr\_accessor with typecast feature.

## Requirements
- Ruby 2.0 or later

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attr_typecastable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_typecastable

## Default Typecasters
- Object (no typecasting)
- String
- Symbol
- Integer
- Float
- Rational
- BigDecimal
- Boolean
- Time
- Date
- DateTime
- ArrayFactory (Array Typecaster builder)

## Usage

```ruby
require 'attr_typecastable'

# Custome typecaster definition
class CastToMoney < AttrTypecastable::Types::Base
  private

  # must define #do_typecast method
  def do_typecast(value)
    # can use @options
    # @options is hash given to `typed_attr_accessor`
    return value if value.is_a?(Money)

    if value.is_a?(Integer)
      Money.new(value)
    else
      raise AttrTypecastable::Types::CastError, "Cannot convert to Money"
    end
  end
end

class User
  # define typed_attr_accessor and initialize hook
  include AttrTypecastable

  typed_attr_accessor :name, String

  # String typecaster uses #to_s
  typed_attr_accessor :default_name, String, default: "Foo"
  typed_attr_accessor :not_nil_name, String, allow_nil: false, default: ""

  # Date typecaster uses #to_date
  typed_attr_accessor :birthday, Date

  # Time typecaster uses #to_time
  typed_attr_accessor :birthday_time, Time

  # DateTime typecaster uses #to_time and #to_datetime
  typed_attr_accessor :birthday_datetime, DateTime

  # Integer typecaster uses #to_i
  typed_attr_accessor :age, Integer

  # Float typecaster uses #to_f
  typed_attr_accessor :bmi, Float

  # Custom Typecaster
  typed_attr_accessor :property, CastToMoney

  # Boolean typecaster uses `#===` method in order to check whether value is true or false.
  typed_attr_accessor :adult, Boolean # default true_values: ["true", 1], false_values: ["false", 0]
  typed_attr_accessor :admin, Boolean, true_values: ["yes"], false_values: ["no"]
  typed_attr_accessor :active, Boolean, true_values: [/true/i], false_value: [/false/i] # can use Regexp

  def initialize(name: nil, default_name: nil)
    self.name = name
    self.default_name = default_name
  end
end

user = User.new
user.name          # => nil
user.default_name  # => "Foo"

user.name = 1
user.name          # => "1"

user.birthday = "1990-10-1"
user.birthday      # => Mon, 01 Oct 1990

user.adult = "true"
user.adult         # => true

user.adult = "false"
user.adult         # => false

user.adult = "other"
user.adult         # => true

user.admin = "yes"
user.admin         # => true

user.active = "TrUe"
user.active        # => true
user.active = "FALSE"
user.active        # => false

user2 = User.new(default_name: "joker")
user2.default_name # => "joker"
```


## Contributing

1. Fork it ( https://github.com/joker1007/attr_typecastable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
