class Campaign < ActiveRecord::Base
  has_many :shots, dependent: :restrict_with_error
  has_many :emails, through: :shots

  validates :name, presence: true

  def self.postback(events)
    events.each do |event|
      shot = Shot.where(id: event['shot_id']).first
      shot.update_attribute("#{event['event']}_at".to_sym, Time.zone.now)
    end
  end
end
