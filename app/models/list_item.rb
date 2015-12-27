class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :email

  has_many :shots, dependent: :restrict_with_error
  has_many :campaigns, through: :shots

  validates :list_id, :email_id, presence: true
  validates :email_id, uniqueness: {scope: :list_id}

  scope :valid, -> { joins(:email).where(emails: {verification_result: 'Ok'}) }
end
