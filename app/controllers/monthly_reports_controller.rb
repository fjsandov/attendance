class MonthlyReportsController < ApplicationController
  load_and_authorize_resource :user
  authorize_resource :monthly_report, through: :user

  # POST /users/{user_id}/monthly-reports
  def create
    @monthly_report = MonthlyReport.new(monthly_report_params)
    if @monthly_report.valid?
      render json: @monthly_report.generate_report, status: :created
    else
      render json: @monthly_report.errors, status: :unprocessable_entity
    end
  end

  private

  def monthly_report_params
    params.require(:monthly_report).permit(:month, :year).merge(user: @user)
  end
end
