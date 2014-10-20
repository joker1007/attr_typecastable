require 'date'
require 'active_support'

require 'attr_typecastable/types/exception'
require 'attr_typecastable/types/string'
require 'attr_typecastable/types/integer'
require 'attr_typecastable/types/time'
require 'attr_typecastable/types/date'
require 'attr_typecastable/types/date_time'
require 'attr_typecastable/types/float'

module AttrTypecastable
  module Types
    BASIC_TYPES = {
      ::String => AttrTypecastable::Types::String,
      ::Integer => AttrTypecastable::Types::Integer,
      ::Time => AttrTypecastable::Types::Time,
      ::Date => AttrTypecastable::Types::Date,
      ::DateTime => AttrTypecastable::Types::DateTime,
      ::Float => AttrTypecastable::Types::Float,
    }.freeze

    class << self
      def find_typecaster(typecaster, **options)
        const = typecaster.is_a?(String) ? typecaster.constantize : typecaster
        BASIC_TYPES.fetch(const, const)
      rescue NameError
        raise TypeCasterNotFound, "#{typecaster} is undefined"
      end
    end
  end
end
