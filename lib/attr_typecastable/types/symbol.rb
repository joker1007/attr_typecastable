require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class Symbol < Base
      def do_typecast(value)
        return value if value.is_a?(::Symbol)

        if value.respond_to?(:to_sym)
          value.to_sym
        else
          raise CastError, "value does not have `to_sym` method"
        end
      end
    end
  end
end
