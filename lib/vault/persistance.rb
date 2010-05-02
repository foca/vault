module Vault
  module Persistance
    extend ActiveSupport::Concern

    included do
      cattr_accessor :store
      self.store = {}
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
      return false unless valid? if run_validations
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
