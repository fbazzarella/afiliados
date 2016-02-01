class Shot < ActiveRecord::Base
  belongs_to :list_item
  belongs_to :campaign

  has_many :shot_events, dependent: :destroy
  has_many :links,       dependent: :destroy

  validates :list_item_id, :campaign_id, presence: true
  validates :list_item_id, uniqueness: {scope: :campaign_id}

  # default_scope -> { includes(:list_item, :campaign) }

  scope :queued,   -> { where.not(queued_at: nil) }
  scope :unqueued, -> { where(queued_at: nil) }

  scope :relayed,   -> { where.not(relayed_at: nil) }
  scope :unrelayed, -> { where(relayed_at: nil) }

  scope :opened,   -> { where.not(opened_at: nil) }
  scope :unopened, -> { where(opened_at: nil) }

  scope :clicked,   -> { where.not(clicked_at: nil) }
  scope :unclicked, -> { where(clicked_at: nil) }

  scope :unsubscribed, -> { where.not(unsubscribed_at: nil) }
  scope :subscribed,   -> { where(unsubscribed_at: nil) }

  # scope :delivered,   -> { joins(:shot_events).where(shot_events: {event: 'delivered'}).distinct }
  # scope :undelivered, -> { joins(:shot_events).where.not(shot_events: {event: 'delivered'}).distinct } # Não funciona! Mais jobs falharam em produção. Comparar tudo! # Parece que o distinct resolve o problema :D

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

  def shoot!
    CampaignMailer.delay.shot(self)
    touch(:queued_at)
  end
end
