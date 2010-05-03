require "yaml"
require "active_support/core_ext/module/delegation"

module Vault
  module Storage
    class YamlStore
      include Enumerable

      delegate :[], :[]=, :size, :each, :delete, :to => :doc

      def initialize(file=nil)
        @file = file
        at_exit { flush if @file.present? }
      end

      def initialize_copy(*)
        @file = nil
      end

      def filter(query)
        results = doc.inject(ActiveSupport::OrderedHash.new) do |result, (key, properties)|
          result[key] = properties if Set.new(properties).superset?(Set.new(query))
          result
        end

        filtered_copy(results)
      end

      def flush
        File.open(@file, "w+") {|f| YAML.dump(@doc, f) }
      end

      protected

      def doc=(doc)
        @doc = doc
      end

      private

      def filtered_copy(doc)
        dup.tap {|store| store.doc = doc }
      end

      def doc
        @doc ||= ActiveSupport::OrderedHash.new(YAML.load_file(@file))
      end
    end
  end
end
