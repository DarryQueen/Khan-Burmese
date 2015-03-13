class User < ActiveRecord::Base
  ROLES = %w[superadmin admin volunteer]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role,
                  :name, :city, :country, :country, :bio

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  after_create :assign_default_role

  def is?(role)
    role.to_s == self.role
  end

  def assign_default_role
    self.role ||= 'volunteer'
    self.save
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity)
    # which can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed:
    if user.nil?
      # Get the existing user by email:
      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration:
      if user.nil?
        user = User.new(
          :email => email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          :password => Devise.friendly_token[0, 20]
        )
        user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save!
      end
    end

    # Associate the identity with the user if needed:
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
end
