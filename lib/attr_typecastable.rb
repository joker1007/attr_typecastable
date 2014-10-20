require "attr_typecastable/version"
require "attr_typecastable/types"
require "attr_typecastable/initialize_hook"

require "active_support/concern"
require "active_support/core_ext/class"
require "active_support/core_ext/hash"

module AttrTypecastable
  extend ActiveSupport::Concern

  included do
    class_attribute(:typed_attr_options)
    self.typed_attr_options = {}
    prepend InitializeHook
  end

  module ClassMethods
    DEFAULT_OPTIONS = {
      allow_nil: true,
      cast_method: true,
      reset_method: true,
    }.freeze

    def typed_attr_accessor(attribute_name, typecaster, **options)
      options = DEFAULT_OPTIONS.merge(options)
      must_have_default_when_disallow_nil(options)

      typed_attr_options[attribute_name] = options

      attr_reader attribute_name

      define_typed_attr_writer(
        attribute_name,
        Types.find_typecaster(typecaster),
        typed_attr_options[attribute_name]
      )

      define_cast_attribute(attribute_name) if options[:cast_method]
      define_reset_attribute(attribute_name, typed_attr_options[attribute_name]) if options[:reset_method]
    end

    private

    def define_typed_attr_writer(attribute_name, typecaster, **options)
      define_method("#{attribute_name}=") do |value|
        casted_value = typecaster.new(value, options).typecast
        instance_variable_set("@#{attribute_name}", casted_value)
      end
    end

    def define_cast_attribute(attribute_name)
      define_method("cast_#{attribute_name}!") do
        value = instance_variable_get("@#{attribute_name}")
        send("#{attribute_name}=", value)
      end
    end

    def define_reset_attribute(attribute_name, **options)
      define_method("reset_#{attribute_name}!") do
        value = options.key?(:default) ? options[:default] : nil
        send("#{attribute_name}=", value)
      end
    end

    def must_have_default_when_disallow_nil(options)
      raise "Need `default` option when allow_nil is false" \
        if options[:allow_nil].! && options[:default].nil?
    end
  end
end
