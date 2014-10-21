module AttrTypecastable
  module InitializeHook
    def initialize(*)
      super

      self.class.typed_attr_reflections.select {|_, r| r.has_default?}.each do |attr, reflection|
        current = send("#{attr}")
        next unless current.nil?

        default = reflection.default

        v = default.respond_to?(:call) ? default.call(self, attr) : default
        send("#{attr}=", v)
      end
    end
  end
end
