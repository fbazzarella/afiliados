class Shot < ActiveRecord::Base
  has_many :shot_events, dependent: :restrict_with_error
  belongs_to :email
  belongs_to :campaign

  validates :email_id, :campaign_id, presence: true
  validates :email_id, uniqueness: {scope: :campaign_id}

  scope :queued,   -> { where.not(queued_at: nil) }
  scope :unqueued, -> { where(queued_at: nil) }

  def self.postback(events, service)
    events.each do |event|
      shot_id = event['shot_id'] || event['X-Mailgun-Variables']['shot_id']

      find(shot_id) do |shot|
        shot.shot_events.create(service: service, event: event['event'], event_hash: event)
      end
    end
  end
end
