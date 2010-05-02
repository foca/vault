require "active_model"
require "set"

module Vault
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :AttributeAccessors
  autoload :Dirty
  autoload :Properties

  included do
    extend ActiveModel::Naming
    extend Properties

    include AttributeAccessors
    include Dirty

    include ActiveModel::Validations
    include ActiveModel::Conversion
  end

  def initialize(attrs={})
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
    attrs.each do |key, value|
      method = "#{key}="
      __send__(method, value)
    end

    self
  end

  def save(run_validations=true)
    return false unless valid? if run_validations
    @_new = false
  end
end
