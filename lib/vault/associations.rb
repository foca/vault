module Vault
  module Associations
    def self.model_from_name(name, namespace=self.class)
      name.is_a?(Class) ? name : namespace.const_get(name)
    end

    def has_many(name, klass_name=name.to_s.classify, foreign_key="#{self.to_s.underscore.singularize}_key", &block)
      define_method name do
        model = Associations.model_from_name(klass_name)
        HasManyProxy.new(self, model, foreign_key, foreign_key => key, &block)
      end
    end

    def belongs_to(name, klass_name=name.to_s.classify)
      foreign_key = "#{name}_key"

      property(foreign_key)

      define_method name do
        model = Associations.model_from_name(klass_name)
        model[send(foreign_key)]
      end

      define_method "#{name}=" do |object|
        send("#{foreign_key}=", object.key)
      end
    end

    class HasManyProxy < Scoping::Scope
      def initialize(owner, model, foreign_key, conditions={}, &block)
        super(model, conditions)
        @owner = owner
        @foreign_key = foreign_key
        yield self, owner, model if block_given?
      end

      def <<(object)
        object.send("#{@foreign_key}=", @owner.key)
        object.save
        self
      end
    end
  end
end
