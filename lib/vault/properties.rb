module Vault
  module Properties
    def key(key=nil)
      return @_key if key.nil?
      @_key = property(key).name
    end

    def property(name, &block)
      Property.new(name, &block).tap do |prop|
        properties << prop
        define_property_methods(prop.name)

        # FIXME: Ugh, ActiveModel fails with this, I can't do incremental method
        # definition, you have to define them all at once (so undefine/define
        # each time if you don't know all the properties upfront, like here.)
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
          read_attribute(:#{name})
        end

        def #{name}=(value)
          write_attribute(:#{name}, value)
        end
      ruby
    end

    class Property
      attr_reader :name

      def initialize(name, &default)
        @name = name.to_s
        @default = default || lambda {}
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
