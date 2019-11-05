class PeriodsController < ApplicationController
  before_action :set_user
  before_action :set_period, only: %i(update destroy)

  # GET /users/{user_id}/periods
  def index
    render json: @user.periods.as_json(include: :period_deletion, except: :period_deletion_id)
  end

  # POST /users/{user_id}/periods
  def create
    @period = @user.periods.new(started_at: Time.current)
    if @period.save
      render json: @period, status: :created
    else
      render json: @period.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/{user_id}/periods/{id}
  def update
    if @period.update(ended_at: Time.current)
      render json: @period
    else
      render json: @period.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/{user_id}/periods/{id}
  def destroy
    destroy_period_params = params.require(:period_deletion).permit(:reason).merge(user: current_user)
    period_deletion = @period.build_period_deletion(destroy_period_params)
    if period_deletion.save
      head :no_content
    else
      render json: period_deletion.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_period
    @period = @user.periods.find(params[:id])
  end
end
