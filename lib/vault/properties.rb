module Vault
  module Properties
    def key(key=nil)
      return @_key if key.nil?
      @_key = property(key, true).name
    end

    def property(name, primary=false, &block)
      Property.new(name, primary, &block).tap do |prop|
        properties << prop
        define_property_methods(prop.name)

        undefine_attribute_methods
        define_attribute_methods(property_names)
      end
    end

    def properties
      @_properties ||= Set.new
    end

    def property_names
      properties.map(&:name)
    end

    def define_property_methods(name)
      class_eval <<-ruby, __FILE__, __LINE__
        def #{name}
          @_attributes[:#{name}]
        end

        def #{name}=(value)
          @_attributes[:#{name}] = value
        end
      ruby
    end

    class Property
      attr_reader :name

      def initialize(name, primary=false, &default)
        @name = name.to_sym
        @default = default || lambda {}
        @primary = primary
      end

      def primary?
        @primary
      end

      def default
        @default.call
      end

      # Set requires both #hash and #eql? to check for inclusion
      def hash # :nodoc:
        name.hash
      end

      def eql?(other) # :nodoc:
        name == other.name
      end
    end
  end
end
