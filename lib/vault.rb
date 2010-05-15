require "set"
require "active_model"
require "active_support/core_ext/hash/except"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/class/attribute_accessors"

module Vault
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Associations
  autoload :AttributeAccessors
  autoload :BulkAttributes
  autoload :Dirty
  autoload :Finders
  autoload :Persistance
  autoload :Properties
  autoload :Scoping
  autoload :Storage
  autoload :Validations

  module Storage
    extend ActiveSupport::Autoload
    autoload :InMemoryStore
    autoload :YamlStore
  end

  included do
    extend ActiveModel::Naming
    extend Properties
    extend Finders
    extend Scoping
    extend Associations

    include BulkAttributes
    include AttributeAccessors
    include Persistance
    include Dirty
    include Validations

    # Convenience methods to provide ActiveModel's API
    include ActiveModel::Conversion
  end

  def key
    send(self.class.key)
  end
  alias_method :id, :key

  def ==(other)
    key == other.key
  end
end
