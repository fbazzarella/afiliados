class Email < ActiveRecord::Base
  has_many :list_items, dependent: :restrict_with_error
  has_many :lists, through: :list_items

  validates :address, presence: true, uniqueness: true, format: {with: /\A([a-zA-Z0-9._%+-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :verification_result, inclusion: %w(Ok Bad), allow_nil: true

  scope :valid,   -> { where(verification_result: 'Ok') }
  scope :invalid, -> { where(verification_result: 'Bad') }
  scope :unknown, -> { where(verification_result: nil) }
end
