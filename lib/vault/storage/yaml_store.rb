require "yaml"
require "active_support/core_ext/module/delegation"

module Vault
  module Storage
    class YamlStore
      include Enumerable

      delegate :[], :[]=, :size, :each, :delete, :to => :doc

      def initialize(file=nil, contents=ActiveSupport::OrderedHash.new)
        @file = file

        if @file.nil?
          @doc = contents
        else
          at_exit { flush }
        end
      end

      def filter(query)
        filtered = doc.inject(ActiveSupport::OrderedHash.new) do |result, (key, properties)|
          result[key] = properties if Set.new(properties).superset?(Set.new(query))
          result
        end

        self.class.new(nil, filtered)
      end

      def flush
        File.open(@file, "w+") {|f| YAML.dump(@doc, f) }
      end

      private

      def doc
        @doc ||= ActiveSupport::OrderedHash.new(YAML.load_file(@file))
      end
    end
  end
end
