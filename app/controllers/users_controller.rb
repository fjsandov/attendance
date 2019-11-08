class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    render json: @users.enabled
  end

  # POST /users
  def create
    @user = User.new(create_params)
    @user.save!
    render json: @user, status: :created
  end

  # PATCH/PUT /users/{id}
  def update
    @user.update!(update_params)
    render json: @user
  end

  # DELETE /users/{id}
  def destroy
    if current_user == @user
      render json: { errors: 'You cannot deactivate yourself' }, status: :unprocessable_entity and return
    end
    @user.update(active: false)
    head :no_content
  end

  private

  def create_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
