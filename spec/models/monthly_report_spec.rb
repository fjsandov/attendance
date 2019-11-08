require 'rails_helper'

RSpec.describe MonthlyReport, type: :model do
  let(:user) { create(:user) }

  before do
    datetime = Time.current.beginning_of_month + 9.hours
    # 5 periods of 8 hours 45 minutes (8.75 hours each).
    5.times do
      create(:period, user: user, started_at: datetime, ended_at: datetime + 8.hours + 45.minutes)
      datetime += 1.day
    end
  end

  let(:monthly_report) { build(:monthly_report, user: user) }
  subject { monthly_report }

  it { should be_valid }

  describe '#user' do
    it { should validate_presence_of(:user) }
  end

  describe '#month' do
    it { should validate_presence_of(:month) }
    it {
      should validate_numericality_of(:month)
               .only_integer
               .is_greater_than_or_equal_to(1)
               .is_less_than_or_equal_to(12)
    }
  end

  describe '#year' do
    it { should validate_presence_of(:year) }
    it {
      should validate_numericality_of(:year)
               .only_integer
               .is_greater_than_or_equal_to(1970)
    }
  end

  describe '#generate_report' do
    let(:report) { monthly_report.generate_report }
    subject { report }

    describe 'returns a valid json structure' do
      subject { report.keys }
      it { should contain_exactly :user_id, :month, :year, :summary, :periods }
    end

    context 'summary key' do
      let(:summary) { report[:summary] }

      describe 'has a valid json structure' do
        subject { summary.keys }
        it { should contain_exactly :count, :hours }

        context 'count key' do
          subject { summary[:count] }

          it { should equal 5 }
        end

        context 'hours key' do
          subject { summary[:hours] }

          it { should equal 8.75 * 5 }
        end
      end
    end

    context 'periods key' do
      let(:periods) { report[:periods] }
      subject { periods }

      describe 'is an array' do
        it { should be_an_instance_of(Array) }

        context 'a period item' do
          let(:period_item) { periods.first }
          subject { period_item.keys }

          it { should contain_exactly :started_at, :ended_at, :hours }

          context 'hours key' do
            subject { period_item[:hours] }

            it { should equal 8.75 }
          end
        end
      end
    end
  end
end
