module Vault
  module Storage
    class InMemoryStore < Hash
      def filter(query)
        return self if query.blank?

        inject(InMemoryStore.new) do |result, (key, properties)|
          result[key] = properties if properties.merge(query) == properties
          result
        end
      end
    end
  end
end
