module Authenticators
  class Base
    def initialize(params)
      self.params = params
    end

    def authenticate
      raise NotImplementedError
    end

    private

    attr_accessor :params
  end
end
