# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :read, :update, :destroy, to: :crud

    if user.admin?
      can :crud, User
      can :crud, Period
    else
      can %i(show update), User, id: user.id
      can :crud, Period, user_id: user.id
    end
  end
end
