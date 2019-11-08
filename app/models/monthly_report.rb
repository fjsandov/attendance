class MonthlyReport
  include ActiveModel::Model
  attr_accessor :user, :month, :year

  validates :user, presence: true

  validates :month,
            presence: true,
            numericality: {
              only_integer: true,
              less_than_or_equal_to: 12,
              greater_than_or_equal_to: 1
            }
  validates :year,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1970
            }

  def user_id
    user&.id
  end

  def generate_report
    started_at = Date.new(year.to_i, month.to_i, 1).beginning_of_day
    ended_at = started_at.end_of_month
    month_periods = user.periods.complete.where(ended_at: started_at..ended_at)
    periods = month_periods.map do |period|
      {
        started_at: period.started_at,
        ended_at: period.ended_at,
        hours: period.elapsed_time.in_hours
      }
    end
    {
      user_id: user.id,
      month: month,
      year: year,
      summary: {
        count: periods.count,
        hours: periods.map { |period_item| period_item[:hours] }.reduce(0, :+)
      },
      periods: periods
    }
  end
end
