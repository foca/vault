module Vault
  module Storage
    module Lint
      def test_implements_getter
        assert model_klass.respond_to?(:[]), "#{model_klass} should respond to #[]"
      end
    end
  end
end
