require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/base'

require "active_support/core_ext/class"

module AttrTypecastable
  module Types
    class ArrayBase < Base
      class_attribute :inner_typecaster

      private

      def do_typecast(value)
        wrapped = Array(value)
        wrapped.map { |v| inner_typecaster.typecast(v) }
      end
    end

    class ArrayFactory
      def self.build(typecaster_name, **options)
        typecaster = Types.typecaster_for(typecaster_name).new(options)
        klass = Class.new(ArrayBase)
        klass.inner_typecaster = typecaster
        klass
      end
    end
  end
end
