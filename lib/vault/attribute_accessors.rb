module Vault
  module AttributeAccessors
    def initialize(*)
      @_attributes = attributes_from_model_properties
      super
    end

    def write_attribute(name, value)
      @_attributes[name] = value
    end

    def read_attribute(name)
      @_attributes[name]
    end

    def attributes
      @_attributes
    end

    private

    def attributes_from_model_properties
      self.class.properties.inject(HashWithIndifferentAccess.new) do |props, prop|
        props[prop.name] = prop.default
        props
      end
    end
  end
end
