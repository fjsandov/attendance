module Errors
  class Unauthorized < Errors::StandardError
    def initialize(exception = nil)
      super(
        title: 'Unauthorized',
        status: 401,
        detail: 'You need to login to be authorized.',
        source: { pointer: '/request/headers/authorization' }
      )
    end
  end
end
