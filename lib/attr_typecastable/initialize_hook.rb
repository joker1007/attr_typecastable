module AttrTypecastable
  module InitializeHook
    def initialize(*)
      super

      self.class.typed_attr_reflections.select {|_, r| r.has_default?}.each do |attr, reflection|
        current = send("#{attr}")

        send("#{attr}=", reflection.default) if current.nil?
      end
    end
  end
end
