class Import < ActiveRecord::Base
  has_many :videos

  before_create :set_default_values

  def set_default_values
    self.time_imported = Time.now
    self.success = true
  end
end