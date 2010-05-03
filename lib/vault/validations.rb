module Vault
  module Validations
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations
    end

    def errors
      @_errors ||= ActiveModel::Errors.new
    end
  end
end
