class Shot < ActiveRecord::Base
  has_many :shot_events, dependent: :restrict_with_error
  belongs_to :email
  belongs_to :campaign

  validates :email_id, :campaign_id, presence: true
  validates :email_id, uniqueness: {scope: :campaign_id}

  scope :queued,   -> { where.not(queued_at: nil) }
  scope :unqueued, -> { where(queued_at: nil) }

  scope :relayed,   -> { where.not(relayed_at: nil) }
  scope :unrelayed, -> { where(relayed_at: nil) }

  class << self
    def postback(params)
      return false unless %w(sendgrid mailgun).include?(service = params.delete('service'))

      send("#{service}_params".to_sym, params).each do |event|
        shot_event_attributes = {service: service, event: event['event'], event_hash: event}
        find(event['shot_id']).shot_events.create(shot_event_attributes)
      end
    end

    private

    def sendgrid_params(params)
      params['_json']
    end

    def mailgun_params(params)
      [params]
    end
  end

  def shot!
    CampaignMailer.delay.shot(self)
    touch(:queued_at)
  end
end
