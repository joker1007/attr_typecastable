require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

require 'date'
require 'active_support/core_ext/string'

module AttrTypecastable
  module Types
    class Date < Base
      def do_typecast
        return @value if @value.is_a?(::Date)

        if @value.respond_to?(:to_date)
          @value.to_date
        else
          raise CastError, "value does not have `to_date` method"
        end
      end
    end
  end
end
