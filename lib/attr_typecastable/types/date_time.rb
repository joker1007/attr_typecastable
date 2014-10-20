require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

require 'date'
require 'active_support/core_ext/string'

module AttrTypecastable
  module Types
    class DateTime < Base
      def do_typecast
        return @value if @value.is_a?(::DateTime)

        case @value
        when ::String
          @value.to_time.to_datetime
        when ::Time, ::Date
          @value.to_datetime
        else
          raise CastError, "cannot convert to DateTime"
        end
      end
    end
  end
end
