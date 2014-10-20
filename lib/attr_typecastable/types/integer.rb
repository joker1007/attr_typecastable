require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class Integer < Base
      def do_typecast(value)
        return value if value.is_a?(::Integer)

        if value.respond_to?(:to_i)
          value.to_i
        else
          raise CastError, "value does not have `to_i` method"
        end
      end
    end
  end
end
