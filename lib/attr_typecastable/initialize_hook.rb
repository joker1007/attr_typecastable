module AttrTypecastable
  module InitializeHook
    def initialize(*)
      super

      self.class.typed_attr_options.each do |attr, options|
        current = send("#{attr}")

        send("#{attr}=", options[:default]) if current.nil?
      end
    end
  end
end
