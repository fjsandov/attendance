require 'rails_helper'

RSpec.describe PeriodDeletion, type: :model do
  let(:period) { build(:period) }
  let(:user) { period.user }
  let(:period_deletion) { period.build_period_deletion(user: user, reason: Faker::Lorem.paragraph) }
  subject { period_deletion }

  it { should be_valid }

  describe 'associations' do
    it { should have_one(:period) }
    it { should belong_to(:user) }
  end

  describe '#reason' do
    it { should validate_presence_of(:reason) }
  end

  describe '#user_id' do
    context 'deleted by the period owner' do
      it { should be_valid }
    end

    context 'deleted by an administrator' do
      let(:user) { create(:admin) }
      it { should be_valid }
    end

    context 'deleted by another regular user' do
      let(:user) { create(:user) }
      it { should be_invalid }
    end
  end

  context 'when the period was already deleted' do
    before do
      period.create_period_deletion(user: user, reason: Faker::Lorem.paragraph)
    end

    it { should be_invalid }
  end
end
