module AttrTypecastable
  module Types
    class Base
      def initialize(value, **options)
        @options = options
        @value = value
      end

      def typecast
        return nil if allow_nil_and_nil_value
        do_typecast
      end

      private

      def do_typecast
        raise NotImplementedError
      end

      def allow_nil_and_nil_value
        @options[:allow_nil] && @value.nil?
      end
    end
  end
end
