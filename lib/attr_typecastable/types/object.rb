require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class Object < Base
      private

      def do_typecast(value)
        value
      end
    end
  end
end
