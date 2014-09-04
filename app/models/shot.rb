class Shot < ActiveRecord::Base
  belongs_to :email
  belongs_to :campaign

  validates :email_id, :campaign_id, presence: true
  validates :email_id, uniqueness: {scope: :campaign_id}

  def self.postback(events)
    events.each do |event|
      find(event['shot_id']).touch("#{event['event']}_at".to_sym)
    end
  end
end
