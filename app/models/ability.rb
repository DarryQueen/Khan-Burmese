class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    #Sets the permissions for Admins here
    #Possible features:
    #  -- Setting video priority
    #  -- Awarding points
    #  -- Upgrading Users to Admins
    if user.admin?
      can :manage, User
    else
      #can :read, :all
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
