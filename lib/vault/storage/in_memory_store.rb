module Vault
  module Storage
    class InMemoryStore < Hash
      def filter(query)
        return self if query.blank?

        inject(InMemoryStore.new) do |result, (key, properties)|
          result[key] = properties if Set.new(properties).superset?(Set.new(query))
          result
        end
      end
    end
  end
end
