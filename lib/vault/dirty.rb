module Vault
  module Dirty
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Dirty
    end

    def save(*)
      super.tap do |saved|
        if saved
          if attribute_changed?(self.class.key)
            self.class.store.delete(attribute_was(self.class.key))
          end

          @previously_changed = changes
          changed_attributes.clear
        end
      end
    end

    def write_attribute(name, value)
      name = name.to_s

      if attribute_changed?(name)
        old = changed_attributes[name]
        changed_attributes.delete(name) if old == value
      else
        old = read_attribute(name)
        old = old.dup if old.duplicable?
        changed_attributes[name] = old if old != value
      end

      super(name, value)
    end
  end
end
