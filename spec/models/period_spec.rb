require 'rails_helper'

RSpec.describe Period, type: :model do
  let(:period) { create(:period) }
  subject { period }

  it { should be_valid }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:period_deletion).optional }
  end

  describe '#started_at' do
    it { should validate_presence_of(:started_at) }
  end

  describe '#ended_at' do
    context 'when it ends before it starts' do
      let(:period) { build(:period, started_at: Time.current, ended_at: 5.hours.ago) }
      it { should be_invalid }
    end

    context 'when it is changed the first time' do
      let(:period) { create(:period, ended_at: nil) }
      before { period.ended_at = 6.hours.from_now }
      it { should be_valid }
    end

    context 'when it is changed' do
      let(:period) { create(:period, ended_at: 1.hour.from_now) }
      before { period.ended_at = 6.hours.from_now }
      it { should be_invalid }
    end
  end

  context 'when a second period is created' do
    let(:user) { period.user }
    let(:started_at) { period.started_at }
    let(:ended_at) { period.ended_at }
    let(:another_period) {
      build(
        :period,
        user: user,
        started_at: started_at,
        ended_at: ended_at,
      )
    }
    subject { another_period }

    context 'when is a different owner' do
      let(:user) { create(:user) }

      context 'when it has the same dates' do
        it { should be_valid }
      end
    end

    context 'when is the same owner' do
      context 'when the existent period is open' do
        let(:period) { create(:period, ended_at: nil) }
        let(:started_at) { period.started_at + 1.day }

        it { should be_invalid }
      end

      describe 'it checks overlap cases' do
        context 'when it has the same dates' do
          it { should be_invalid }
        end

        context 'when it contains the existent one range' do
          let(:ended_at) { period.ended_at + 1.hour }
          let(:started_at) { period.started_at - 1.hour }
          it { should be_invalid }
        end

        context 'when it is contained by the existent one range' do
          let(:ended_at) { period.ended_at - 1.second }
          let(:started_at) { period.started_at + 1.second }
          it { should be_invalid }
        end

        context 'when it starts before but ends into the existent one range' do
          let(:started_at) { period.started_at - 1.hour }
          let(:ended_at) { period.started_at + 1.second }
          it { should be_invalid }
        end

        context 'when it ends after but starts into the existent one range' do
          let(:started_at) { period.started_at + 1.second }
          let(:ended_at) { period.ended_at + 1.hour }
          it { should be_invalid }
        end

        context 'when it ends before the existent one starts' do
          let(:ended_at) { period.started_at - 1.hour }
          let(:started_at) { ended_at - 6.hours }
          it { should be_valid }
        end

        context 'when it starts before the existent one ends' do
          let(:started_at) { period.ended_at + 1.second }
          let(:ended_at) { started_at + 6.hours }
          it { should be_valid }
        end
      end
    end
  end
end
