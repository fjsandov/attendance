class PeriodDeletion < ApplicationRecord
  has_one :period
  belongs_to :user

  validates :reason, presence: true
  validate :check_valid_user, :check_delete_once

  private

  def check_valid_user
    return if user.nil? or user.admin? or user == period.user
    errors.add(:user, 'must be an administrator or the period owner')
  end

  def check_delete_once
    return unless Period.deleted.where(id: period.id).exists?
    errors.add(:base, 'attempt to delete a deleted period')
  end
end
