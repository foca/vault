module Vault
  module Persistance
    extend ActiveSupport::Concern

    included do
      cattr_accessor :store
      extend Storage

      store_objects_in Hash.new
    end

    module Storage
      def store_objects_in(store)
        self.store = store
      end
    end

    def initialize(*)
      @_new = true
      @_destroyed = false
      super
    end

    def persisted?
      !@_new && !@_destroyed
    end

    def save(run_validations=true)
      return false if run_validations && !valid?
      self.class.store[key] = attributes_except_key
      @_new = false
      true
    end

    def destroy
      self.class.store.delete(key)
      @_destroyed = true
      freeze
    end

    private

    def attributes_except_key
      attributes.except(self.class.key)
    end
  end
end
