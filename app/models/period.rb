class Period < ApplicationRecord
  belongs_to :user
  belongs_to :period_deletion, optional: true

  attr_accessor :admin_mode
  after_initialize { self.admin_mode ||= false }

  validates :started_at, presence: true
  validate :check_starts_before_ends, :check_overlap, :check_reassign_dates, :check_open_periods

  scope :deleted, -> { where.not(period_deletion: nil) }
  scope :open, -> { where(ended_at: nil) }

  def as_json(options = {})
    super(options.merge({ include: :period_deletion, except: :period_deletion_id }))
  end

  private
  
  def check_open_periods
    return unless user.present?
    if user.periods.open.where.not(id: self.id).count > 0
      errors.add(:base, 'there is already an existent open period')
    end
  end

  def check_reassign_dates
    return if admin_mode # admin mode allows to reassign dates
    if started_at_in_database.present? and started_at_in_database != started_at
      errors.add(:started_at, 'cannot be changed once set')
    end
    if ended_at_in_database.present? and ended_at_in_database != ended_at
      errors.add(:ended_at, 'cannot be changed once set')
    end
  end

  def check_starts_before_ends
    return if started_at.blank? or ended_at.blank?
    errors.add(:ended_at, 'must be after it starts') if started_at >= ended_at
  end

  def check_overlap
    return unless [user, started_at, ended_at].all?
    if id.present?
      return unless Period.exists?(['id != ? AND user_id = ? AND ended_at > ? AND ? > started_at', id, user.id, started_at, ended_at])
    else
      return unless Period.exists?(['user_id = ? AND ended_at > ? AND ? > started_at', user.id, started_at, ended_at])
    end
    errors.add(:base, 'overlaps with another period of the same owner')
  end
end
