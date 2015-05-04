class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :crud

    @user = user || User.new

    # Administrator permissions:
    superadmin if @user.is? :superadmin
    admin if @user.is? :admin
    volunteer if @user.is? :volunteer
  end

  def superadmin
    admin

    # Access the RailsAdmin portal:
    can :access, :rails_admin
    can :dashboard

    # Superior power. Use with discretion.
    # can :manage, :all
  end

  def admin
    volunteer

    # Administrator pages:
    can :access, :admin_dashboard

    # Previews:
    can :read, :prototype

    # Videos:
    can :star, Video
    can :crud, Video
    can :import, :video

    can :manage, User
    cannot [ :destroy, :promote ], User do |promotee|
      promotee > @user
    end
  end

  def volunteer
    # Translations:
    can :upload, Translation, :user_id => @user.id
    can :destroy, Translation do |translation|
      translation.user == @user and not translation.complete?
    end
    can :review, Translation do |translation|
      translation.user != @user and translation.complete?
    end

    # User:
    can :update, User, :id => @user.id
  end
end
