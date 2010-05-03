module Vault
  module Scoping
    extend ActiveSupport::Concern

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

      delegate :new, :key, :model_name, :to => :model

      attr_reader :conditions, :model

      def initialize(model, conditions)
        @model = model
        @conditions = conditions.stringify_keys
      end

      def store
        @store ||= @model.store.filter(conditions)
      end
    end
  end
end
