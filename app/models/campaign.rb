class Campaign < ActiveRecord::Base
  has_many :shots, dependent: :restrict_with_error
  has_many :emails, through: :shots

  validates :name, presence: true

  def self.postback(events)
  end
end
