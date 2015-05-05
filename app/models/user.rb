class User < ActiveRecord::Base
  include Comparable

  ROLES = %w[superadmin admin volunteer]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role,
                  :name, :city, :country, :bio
  acts_as_voter

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_presence_of :name
  validates_inclusion_of :role, :in => ROLES

  before_validation :assign_default_role, :on => :create
  before_save :capitalize_fields
  before_destroy :nullify_translations

  has_many :translations
  has_many :translation_videos, :through => :translations, :source => :video

  def first_name
    names = self.name.rpartition(' ')
    names.first.empty? ? names.last : names.first
  end
  def last_name
    self.name.rpartition(' ').last
  end

  def assigned_videos
    self.translation_videos.select do |video|
      video.translations.select { |t| not t.complete? }.map(&:user).include?(self)
    end
  end
  def translated_videos
    self.translation_videos.select do |video|
      video.translations.select { |t| t.complete? }.map(&:user).include?(self)
    end
  end

  def reviewed_videos
    self.get_voted(Translation).map { |translation| translation.video }.uniq
  end

  def points(after = Time.new(0))
    self.translations.reduce(0) { |sum, translation| sum + ((translation.time_updated > after) ? translation.points : 0) }
  end

  def is?(role)
    role.to_s == self.role
  end

  def assign_default_role
    self.role ||= 'volunteer'
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def <=>(other)
    self.role_value <=> other.role_value
  end
  def role_value
    case self.role
    when 'superadmin' then 100
    when 'admin' then 1
    when 'volunteer' then 0
    end
  end

  def self.roles
    ROLES - [ 'superadmin' ]
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      # Get the existing user by email:
      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration:
      if user.nil?
        user = User.new(
          :email => email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          :password => Devise.friendly_token[0, 20],
          :name => auth.info.name
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

  def self.leaders(after = Time.new(0))
    User.all.sort_by { |user| user.points(after) }.reverse
  end

  # Anonymous user object for translations:
  def self.anonymous_user
    @@anonymous ||= User.new
    class << @@anonymous
      def name
        'Anonymous'
      end
    end
    @@anonymous
  end

  private
  def capitalize_fields
    write_attribute(:name, name.titleize) if name

    write_attribute(:country, country.titleize) if country
    write_attribute(:city, city.titleize) if city
  end

  def nullify_translations
    self.translations.each do |translation|
      if translation.complete?
        translation.user = nil
        translation.save
      else
        translation.destroy
      end
    end
  end
end
