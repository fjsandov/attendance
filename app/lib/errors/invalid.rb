module Errors
  class Invalid < Errors::StandardError
    def initialize(exception)
      if exception.class.name == 'ActiveRecord::RecordInvalid'
        obj = exception.record
      else
        obj = exception.model
      end
      @errors = obj&.errors.to_h || {}
      @status = 422
      @title = 'Unprocessable Entity'
    end

    def to_h
      error_objects = @errors.reduce([]) do |r, (att, msg)|
        r << {
          detail: msg,
          source: { pointer: "/data/attributes/#{att}" }
        }
      end
      {
        status: @status,
        title: @title,
        errors: error_objects
      }
    end
  end
end
