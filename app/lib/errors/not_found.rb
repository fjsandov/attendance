module Errors
  class NotFound < Errors::StandardError
    def initialize(exception = nil)
      super(
        title: 'Record not Found',
        status: 404,
        detail: 'We could not find the object you were looking for.',
        source: { pointer: '/request/url/:id' }
      )
    end
  end
end
