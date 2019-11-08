# Based on: https://driggl.com/blog/a/handling-exceptions-in-rails-applications

module ErrorHandler
  extend ActiveSupport::Concern

  ERRORS = {
    'ActiveRecord::RecordNotFound' => 'Errors::NotFound',
    'ActiveRecord::RecordInvalid' => 'Errors::Invalid',
    'ActiveModel::ValidationError' => 'Errors::Invalid',
    'CanCan::AccessDenied' => 'Errors::Forbidden'
  }

  included do
    rescue_from StandardError, with: :handle_error
  end

  def render_error(errors_hash, status)
    render json: { errors: errors_hash }, status: status
  end

  private

  def handle_error(e)
    mapped = map_error(e)
    # notify about unexpected_error unless mapped
    mapped ||= Errors::StandardError.new
    render_error(mapped.serializable_hash, mapped.status)
  end

  def map_error(e)
    error_klass = e.class.name
    return e if ERRORS.values.include?(error_klass)
    ERRORS[error_klass]&.constantize&.new(e)
  end
end
