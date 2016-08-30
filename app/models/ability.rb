class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    alias_action :create, :update, :destroy, to: :moderate

    alias_action :create, :update, to: :regular_user_crud

    can :read, Proverb

    if user.admin?
      can :manage, :all
    end

    if user.moderator?
      can :moderate, Proverb
      can :manage, User, id: user.id
    end

    if user.regular?
      can :regular_user_crud, :Proverb, user_id: user.id
      can :manage, User, id: user.id
    end
  end
end
