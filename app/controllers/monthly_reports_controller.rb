class MonthlyReportsController < ApplicationController
  load_and_authorize_resource :user
  authorize_resource :monthly_report, through: :user

  # POST /users/{user_id}/monthly-reports
  def create
    @monthly_report = MonthlyReport.new(monthly_report_params)
    @monthly_report.validate!
    render json: @monthly_report.generate_report, status: :created
  end

  private

  def monthly_report_params
    params.require(:monthly_report).permit(:month, :year).merge(user: @user)
  end
end
