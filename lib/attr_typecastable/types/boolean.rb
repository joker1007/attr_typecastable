require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

module AttrTypecastable
  module Types
    class Boolean < Base
      def initialize(**options)
        super
        @options[:true_values] ||= ["true", 1]
        @options[:false_values] ||= ["false", 0]
      end

      def do_typecast(value)
        return value if value.is_a?(::TrueClass) || value.is_a?(::FalseClass)

        true_values = Array(@options[:true_values])
        false_values = Array(@options[:false_values])
        if true_values.any? {|v| v === value }
          true
        elsif false_values.any? {|v| v === value }
          false
        else
          !!value
        end
      end
    end
  end
end
