require "attr_typecastable/version"
require "attr_typecastable/types"
require "attr_typecastable/initialize_hook"
require "attr_typecastable/reflection"

require "active_support/concern"
require "active_support/core_ext/class"
require "active_support/core_ext/hash"

module AttrTypecastable
  extend ActiveSupport::Concern

  included do
    class_attribute(:typed_attr_reflections)
    self.typed_attr_reflections = {}
    prepend InitializeHook
  end

  module ClassMethods
    DEFAULT_OPTIONS = {
      allow_nil: true,
      cast_method: true,
      reset_method: true,
    }.freeze

    def typed_attr_accessor(attribute_name, typecaster_name = Object, **options)
      attribute_name = attribute_name.to_sym
      options = DEFAULT_OPTIONS.merge(options)
      must_have_default_when_disallow_nil(options)

      typecaster = Types.typecaster_for(typecaster_name || Object).new(options)
      typed_attr_reflections[attribute_name] = Reflection.new(attribute_name, typecaster, options)

      attr_reader attribute_name

      define_typed_attr_writer(attribute_name)
      define_cast_attribute(attribute_name) if options[:cast_method]
      define_reset_attribute(attribute_name) if options[:reset_method]
    end

    private

    def define_typed_attr_writer(attribute_name)
      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{attribute_name}=(value)
          typecaster = self.class.typed_attr_reflections[:#{attribute_name}].typecaster
          @#{attribute_name} = typecaster.typecast(value)
        end
      RUBY
    end

    def define_cast_attribute(attribute_name)
      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def cast_#{attribute_name}!
          value = @#{attribute_name}
          self.#{attribute_name} = value
        end
      RUBY
    end

    def define_reset_attribute(attribute_name, **options)
      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def reset_#{attribute_name}!
          default = self.class.typed_attr_reflections[:#{attribute_name}].default
          value = default.respond_to?(:call) ? default.call(self, :#{attribute_name}) : default
          self.#{attribute_name} = value
        end
      RUBY
    end

    def must_have_default_when_disallow_nil(options)
      raise "Need `default` option when allow_nil is false" \
        if options[:allow_nil].! && options[:default].nil?
    end
  end
end
