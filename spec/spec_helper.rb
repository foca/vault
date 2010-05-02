require "spec"
require "vault"

module SpecHelpers
  def model(&block)
    Class.new do
      include Vault
      instance_eval(&block) if block
    end
  end
end

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
