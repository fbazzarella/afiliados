class Shot < ActiveRecord::Base
  belongs_to :email
  belongs_to :campaign

  delegate :verified_at, to: :email

  validates :email_id, :campaign_id, presence: true
end
