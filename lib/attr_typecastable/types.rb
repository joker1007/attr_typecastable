require 'date'
require 'active_support'

require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/string'
require 'attr_typecastable/types/integer'
require 'attr_typecastable/types/time'
require 'attr_typecastable/types/date'
require 'attr_typecastable/types/date_time'
require 'attr_typecastable/types/float'
require 'attr_typecastable/types/rational'
require 'attr_typecastable/types/boolean'
require 'attr_typecastable/types/object'

unless defined?(::Boolean)
  class Boolean; end
end

module AttrTypecastable
  module Types
    BASIC_TYPES = {
      ::Object => AttrTypecastable::Types::Object,
      ::String => AttrTypecastable::Types::String,
      ::Integer => AttrTypecastable::Types::Integer,
      ::Time => AttrTypecastable::Types::Time,
      ::Date => AttrTypecastable::Types::Date,
      ::DateTime => AttrTypecastable::Types::DateTime,
      ::Float => AttrTypecastable::Types::Float,
      ::Rational => AttrTypecastable::Types::Rational,
      ::Boolean => AttrTypecastable::Types::Boolean,
    }.freeze

    class << self
      def typecaster_for(typecaster, **options)
        const = typecaster.is_a?(String) ? typecaster.constantize : typecaster
        BASIC_TYPES.fetch(const, const)
      rescue NameError
        raise TypeCasterNotFound, "#{typecaster} is undefined"
      end
    end
  end
end
