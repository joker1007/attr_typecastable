module AttrTypecastable
  module Types
    class Base
      def initialize(**options)
        @options = options
      end

      def typecast(value)
        return nil if allow_nil_and_nil_value?(value)
        do_typecast(value)
      end

      private

      def do_typecast(value)
        raise NotImplementedError
      end

      def allow_nil_and_nil_value?(value)
        @options[:allow_nil] && value.nil?
      end
    end
  end
end
