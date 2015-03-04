class Identity < ActiveRecord::Base
  belongs_to :user
  attr_accessible :uid, :provider
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_by_provider_and_uid(auth.provider, auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity
  end
end
