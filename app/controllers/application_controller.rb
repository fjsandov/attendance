class ApplicationController < ActionController::API
  include ErrorHandler

  before_action :authenticate_user!
  check_authorization unless: :devise_controller?
end
