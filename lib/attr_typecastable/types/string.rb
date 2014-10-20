require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class String < Base
      def do_typecast
        return @value if @value.is_a?(::String)

        if @value.respond_to?(:to_s)
          @value.to_s
        else
          raise CastError, "value does not have `to_s` method"
        end
      end
    end
  end
end
