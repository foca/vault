module Vault
  module Scoping
    def scopes
      @_scopes ||= Hash.new
    end

    def scope(name, &conditions)
      name = name.to_s
      scopes[name] = Scope.new(self, conditions.call)
      define_scope_method(name)
    end

    private

    def define_scope_method(name)
      singleton_class.instance_eval do
        define_method name do
          scopes[name]
        end
      end
    end

    class Scope
      include Finders

      delegate :key, :model_name, :to => :model

      attr_reader :conditions, :model

      def initialize(model, conditions)
        @model = model
        @conditions = conditions.stringify_keys
      end

      def store
        @store ||= @model.store.filter(conditions)
      end

      def new(attrs={})
        @model.new(conditions.merge(attrs))
      end

      def method_missing(method, *)
        if model_has_scope?(method)
          merge(model.scopes[method.to_s])
        else
          super
        end
      end

      def respond_to?(method, include_private=false)
        model_has_scope?(method) || super
      end

      private

      def model_has_scope?(name)
        model.scopes.include?(name.to_s)
      end

      def merge(scope)
        Scope.new(model, conditions.merge(scope.conditions))
      end
    end
  end
end
