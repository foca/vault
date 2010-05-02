require "active_support/ordered_hash"
require "active_model"
require "set"

module Vault
  extend ActiveSupport::Concern

  autoload :Properties, "vault/properties"

  included do
    extend ActiveModel::Naming
    extend Properties

    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveModel::Conversion
  end

  def initialize(attrs={})
    @_attributes = attributes_from_model_properties
    @_new = true
    @_destroyed = false
    update(attrs)
  end

  def key
    send(self.class.key)
  end
  alias_method :id, :key

  def errors
    @_errors ||= ActiveModel::Errors.new
  end

  def persisted?
    !@_new && !@_destroyed
  end

  def update(attrs={})
    @_attributes.update(attrs)
    self
  end

  def save(run_validations=true)
    return false unless valid? if run_validations
    @_new = false
  end

  private

  def attributes_from_model_properties
    self.class.properties.inject({}) do |props, prop|
      props[prop.name] = prop.default
      props
    end
  end
end
