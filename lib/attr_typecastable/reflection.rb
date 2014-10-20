module AttrTypecastable
  class Reflection
    attr_reader :attribute_name, :typecaster, :options

    def initialize(attribute_name, typecaster, **options)
      @attribute_name = attribute_name
      @typecaster = typecaster
      @options = options
      freeze
    end

    def default
      @options[:default]
    end

    def has_default?
      @options.key?(:default)
    end
  end
end
