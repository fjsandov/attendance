class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    response_json = self.resource.as_json
    response_json['jwt_token'] = request.env['warden-jwt_auth.token']
    render json: response_json
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end
