class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Administrator permissions:
    superadmin if user.is? :superadmin
    admin if user.is? :admin
    volunteer if user.is? :volunteer
  end

  def superadmin
    admin

    # Access the RailsAdmin portal:
    can :access, :rails_admin
    can :dashboard

    # Videos:
    can :star, :videos

    # Superior power. Use with discretion.
    can :manage, :all
  end

  def admin
    volunteer

    can :manage, User
  end

  def volunteer
  end
end
