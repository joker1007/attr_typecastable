require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class Rational < Base
      def do_typecast(value)
        return value if value.is_a?(::Rational)

        if value.respond_to?(:to_r)
          value.to_r
        else
          raise CastError, "value does not have `to_r` method"
        end
      end
    end
  end
end
