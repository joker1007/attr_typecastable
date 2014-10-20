require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class Float < Base
      def do_typecast
        return @value if @value.is_a?(::Float)

        if @value.respond_to?(:to_f)
          @value.to_f
        else
          raise CastError, "value does not have `to_f` method"
        end
      end
    end
  end
end
