class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Administrator permissions:
    if user.admin?
      # Access the rails_admin console:
      can :access, :rails_admin
      can :dashboard

      # Manage all:
      can :manage, :all
    end
  end
end
