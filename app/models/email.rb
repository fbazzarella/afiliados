class Email < ActiveRecord::Base
  has_many :shots, dependent: :restrict_with_error
  has_many :campaigns, through: :shots

  validates :address, presence: true, uniqueness: true, format: {with: /\A([a-zA-Z0-9._%+-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
end
