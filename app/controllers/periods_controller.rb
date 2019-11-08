class PeriodsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :period, through: :user

  # GET /users/{user_id}/periods
  def index
    render json: @periods
  end

  # POST /users/{user_id}/periods
  def create
    @period = @user.periods.new(create_params)
    @period.admin_mode = current_user.admin?
    @period.save!
    render json: @period, status: :created
  end

  # PATCH/PUT /users/{user_id}/periods/{id}
  def update
    @period.admin_mode = current_user.admin?
    @period.update!(update_params)
    render json: @period
  end

  # DELETE /users/{user_id}/periods/{id}
  def destroy
    period_deletion = @period.build_period_deletion(destroy_params)
    period_deletion.save!
    head :no_content
  end

  private

  def admin_period_params
    params.require(:period).permit(:started_at, :ended_at)
  end

  def create_params
    current_user.admin? ? admin_period_params :  { started_at: Time.current }
  end

  def update_params
    current_user.admin? ? admin_period_params : { ended_at: Time.current }
  end

  def destroy_params
    params.require(:period_deletion).permit(:reason).merge(user: current_user)
  end
end
