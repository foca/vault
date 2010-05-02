require "spec"
require "vault"

module SpecHelpers
  class BaseModel
    include Vault
  end

  def model(base=BaseModel, &block)
    Class.new(base, &block)
  end
end

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
