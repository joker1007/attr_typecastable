module AttrTypecastable
  class Reflection
    attr_reader :attribute_name, :typecaster, :options

    def initialize(attribute_name, typecaster, **options)
      @attribute_name = attribute_name
      @typecaster = typecaster
      @options = options
      freeze
    end

    def allow_nil
      @options[:allow_nil]
    end

    def cast_method
      @options[:cast_method]
    end

    def reset_method
      @options[:reset_method]
    end

    def default
      @options[:default]
    end

    def has_default?
      @options.key?(:default)
    end
  end
end
