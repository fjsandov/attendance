class ApplicationController < ActionController::API
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end
end
