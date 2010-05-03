require "spec"
require "vault"

Dir["spec/support/**/*.rb"].each {|f| require f }

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
