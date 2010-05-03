module SpecHelpers
  def model(&block)
    Class.new do
      include Vault
      class_eval(&block) if block
    end
  end

  def named_model(name, &block)
    model = model(&block)
    self.class.class_eval do
      remove_const(name) if const_defined?(name)
      const_set(name, model)
    end
  end
end
