class Ability
  include CanCan::Ability

  def initialize(user)
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
    can :manage, :all
  end

  def admin
    volunteer

    # Previews:
    can :read, :prototype

    # Videos:
    can :star, Video
    can :import, :video

    can :manage, User
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
    can :edit, User, :id => @user.id
  end
end
