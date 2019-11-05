class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    render json: @users
  end
end
