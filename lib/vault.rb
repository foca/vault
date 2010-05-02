require "set"
require "active_model"
require "active_support/core_ext/class/attribute_accessors"

module Vault
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :AttributeAccessors
  autoload :Dirty
  autoload :Properties
  autoload :Persistance

  included do
    extend ActiveModel::Naming
    extend Properties

    include AttributeAccessors
    include Persistance
    include Dirty

    include ActiveModel::Validations
    include ActiveModel::Conversion
  end

  def initialize(attrs={})
    update(attrs)
  end

  def key
    send(self.class.key)
  end
  alias_method :id, :key

  def errors
    @_errors ||= ActiveModel::Errors.new
  end

  def update(attrs={})
    attrs.each do |key, value|
      method = "#{key}="
      __send__(method, value)
    end

    self
  end
end
