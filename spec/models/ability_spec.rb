require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:user) { create(:user) }
  let(:user_resource) { build(:user) }
  let(:period_resource) { build(:period) }
  let(:monthly_report_resource) { build(:monthly_report) }

  subject { Ability.new(user) }

  context 'when is an administrator' do
    let(:user) { create(:admin) }

    context 'Users resource' do
      %i(index show new create update destroy).each do |role|
        it{ should be_able_to(role, user_resource) }
      end
    end

    context 'Period resource' do
      %i(index show new create update destroy).each do |role|
        it{ should be_able_to(role, period_resource) }
      end
    end

    context 'Monthly report resource' do
      %i(index show new create update destroy).each do |role|
        it{ should be_able_to(role, monthly_report_resource) }
      end
    end
  end

  context 'when is a normal user' do
    context 'Users resource' do
      context 'when accessing another user' do
        %i(index show new create update destroy).each do |role|
          it{ should_not be_able_to(role, user_resource) }
        end
      end

      context 'when accessing himself' do
        %i(show update).each do |role|
          it{ should be_able_to(role, user) }
        end

        %i(index new create destroy).each do |role|
          it{ should_not be_able_to(role, user) }
        end
      end
    end

    context 'Period resource' do
      context 'when accessing another user periods' do
        %i(index show new create update destroy).each do |role|
          it{ should_not be_able_to(role, period_resource) }
        end
      end

      context 'when accessing own periods' do
        let(:period_resource) { build(:period, user: user) }

        %i(index show new create update destroy).each do |role|
          it{ should be_able_to(role, period_resource) }
        end
      end
    end

    context 'Monthly report resource' do
      context 'when accessing another user monthly reports' do
        %i(index show new create update destroy).each do |role|
          it{ should_not be_able_to(role, monthly_report_resource) }
        end
      end

      context 'when accessing own monthly reports' do
        let(:monthly_report_resource) { build(:monthly_report, user: user) }

        %i(index show new create update destroy).each do |role|
          it{ should be_able_to(role, monthly_report_resource) }
        end
      end
    end
  end
end
