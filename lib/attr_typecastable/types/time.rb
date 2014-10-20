require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

require 'active_support/core_ext/string'

module AttrTypecastable
  module Types
    class Time < Base
      def do_typecast(value)
        return value if value.is_a?(::Time)

        if value.respond_to?(:to_time)
          value.to_time
        else
          raise CastError, "value does not have `to_time` method"
        end
      end
    end
  end
end
