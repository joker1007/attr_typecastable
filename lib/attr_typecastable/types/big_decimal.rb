require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'
module AttrTypecastable
  module Types
    class BigDecimal < Base
      def do_typecast(value)
        require 'bigdecimal/util'

        return value if value.is_a?(::BigDecimal)

        if value.is_a?(::Rational)
          if @options[:fig]
            value.to_d(@options[:fig])
          else
            value.to_f.to_d
          end
        elsif value.is_a?(::Float)
          if @options[:precision]
            value.to_d(@options[:precision])
          else
            value.to_d
          end
        elsif value.respond_to?(:to_d)
          value.to_d
        else
          BigDecimal.new(value.to_s)
        end
      end
    end
  end
end
