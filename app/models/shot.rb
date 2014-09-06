class Shot < ActiveRecord::Base
  belongs_to :email
  belongs_to :campaign
  has_many :shot_events, dependent: :restrict_with_error

  validates :email_id, :campaign_id, presence: true
  validates :email_id, uniqueness: {scope: :campaign_id}

  scope :queued,   -> { where.not(queued_at: nil) }
  scope :unqueued, -> { where(queued_at: nil) }

  def self.postback(events)
    events.each do |event|
      find(event['shot_id']).touch("#{event['event']}_at".to_sym)
    end
  end
end
