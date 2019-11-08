module Errors
  class Forbidden < Errors::StandardError
    def initialize(exception = nil)
      super(
        title: 'Forbidden',
        status: 403,
        detail: 'You need to login with an account that has the required credentials.',
        source: { pointer: '/request/headers/authorization' }
      )
    end
  end
end
