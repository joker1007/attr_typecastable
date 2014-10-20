require "attr_typecastable/version"
require "attr_typecastable/types"
require "attr_typecastable/initialize_hook"

require "active_support/concern"
require "active_support/core_ext/class"
require "active_support/core_ext/hash"

module AttrTypecastable
  extend ActiveSupport::Concern

  included do
    class_attribute(:typed_attr_default_values)
    class_attribute(:typed_attr_options)
    self.typed_attr_default_values = {}
    self.typed_attr_options = {}
    prepend InitializeHook
  end

  module ClassMethods
    DEFAULT_OPTIONS = {
      allow_nil: true,
      default: nil,
    }.freeze

    def typed_attr_accessor(attribute_name, typecaster, **options)
      options = DEFAULT_OPTIONS.merge(options)
      raise "Need `default` option when allow_nil is false" if disallow_nil_and_no_default?(options)

      default_value = options.delete(:default)
      self.typed_attr_default_values[attribute_name] = default_value if default_value

      self.typed_attr_options[attribute_name] = options

      define_method(attribute_name) do
        instance_variable_get("@#{attribute_name}")
      end

      define_method("#{attribute_name}=") do |value|
        t = Types.find_typecaster(typecaster)
        casted_value = t.new(value, self.typed_attr_options[attribute_name]).typecast
        instance_variable_set("@#{attribute_name}", casted_value)
      end

      define_method("cast_#{attribute_name}!") do
        value = send(attribute_name)
        send("#{attribute_name}=", value)
      end
    end

    private

    def disallow_nil_and_no_default?(options)
      options[:allow_nil].! && options[:default].nil?
    end
  end
end
