require "spec"
require "vault"

module SpecHelpers
  class BaseModel
    include Vault
  end

  def model(name=nil, &block)
    Class.new(BaseModel, &block).tap do |model|
      if name.present?
        self.class.class_eval do
          remove_const(name) if const_defined?(name)
          const_set(name, model)
        end
      end
    end
  end
end

Dir["spec/support/**/*.rb"].each {|f| require f }

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
