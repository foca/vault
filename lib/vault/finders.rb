module Vault
  module Finders
    def all
      store.map do |key_value, properties|
        build(key_value, properties)
      end
    end

    def find(key_value)
      properties = store[key_value]
      build(key_value, properties) if properties
    end

    private

    def build(key_value, properties)
      new(properties.update(key => key_value))
    end
  end
end
