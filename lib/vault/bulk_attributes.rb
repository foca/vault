module Vault
  module BulkAttributes
    def initialize(attrs={})
      update(attrs)
      changed_attributes.clear
    end

    def update(attrs={})
      attrs.each do |key, value|
        method = "#{key}="
        __send__(method, value)
      end

      self
    end
  end
end
