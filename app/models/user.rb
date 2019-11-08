class User < ApplicationRecord
  devise :database_authenticatable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
  has_many :periods

  validates :password_confirmation, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :update, if: :will_save_change_to_encrypted_password?

  scope :enabled, -> { where(active: true) }

  def as_json(options = {})
    super(options.merge({ except: :active }))
  end

  def active_for_authentication?
    super and active
  end
end
