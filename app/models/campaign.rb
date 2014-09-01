class Campaign < ActiveRecord::Base
  has_many :shots
  has_many :emails, through: :shots

  validates :name, presence: true
end
