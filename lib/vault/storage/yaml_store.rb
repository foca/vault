require "yaml"
require "active_support/core_ext/module/delegation"

module Vault
  module Storage
    class YamlStore
      include Enumerable

      delegate :[], :[]=, :size, :each, :delete, :to => :doc

      def initialize(file)
        @file = file
        at_exit { flush }
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
