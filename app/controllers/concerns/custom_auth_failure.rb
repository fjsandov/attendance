class CustomAuthFailure < Devise::FailureApp
  def respond
    unauthorized = Errors::Unauthorized.new
    self.status = unauthorized.status
    self.content_type = 'application/json'
    self.response_body = unauthorized.to_h.to_json
  end
end
