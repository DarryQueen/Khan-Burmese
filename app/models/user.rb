class User < ActiveRecord::Base
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

  after_create :assign_default_role
  before_save :capitalize_fields

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
    self.save
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def is_translator?
    self.translations.each do |translation|
      if [:complete, :complete_with_priority].include? translation.status_symbol
        return true
      end
    end
    false
  end

  def self.number_of_translators
    sum = 0
    User.all.each do |user|
      sum += user.is_translator? ? 1 : 0
    end
    sum
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
end
