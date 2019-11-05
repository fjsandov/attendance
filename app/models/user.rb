class User < ApplicationRecord
  devise :database_authenticatable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
  has_many :periods
end