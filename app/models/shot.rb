class Shot < ActiveRecord::Base
  belongs_to :email
  belongs_to :campaign

  validates :email_id, :campaign_id, presence: true
end
