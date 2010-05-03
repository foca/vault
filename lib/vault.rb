require "set"
require "active_model"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/class/attribute_accessors"

module Vault
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :AttributeAccessors
  autoload :Dirty
  autoload :Finders
  autoload :Persistance
  autoload :Properties
  autoload :Storage

  module Storage
    extend ActiveSupport::Autoload
    autoload :YamlStore
  end

  included do
    extend ActiveModel::Naming
    extend Properties
    extend Finders

    include AttributeAccessors
    include Persistance
    include Dirty

    include ActiveModel::Validations
    include ActiveModel::Conversion
  end

  def initialize(attrs={})
    update(attrs)
    changed_attributes.clear
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

  def ==(other)
    key == other.key
  end
end
