module AttrTypecastable
  module InitializeHook
    def initialize(*)
      super

      self.class.typed_attr_default_values.each do |attr, default|
        current = send("#{attr}")

        send("#{attr}=", default) if current.nil?
      end
    end
  end
end
