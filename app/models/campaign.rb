class Campaign < ActiveRecord::Base
  has_many :shots, dependent: :restrict_with_error
  has_many :emails, through: :shots

  validates :name, presence: true

  def chase!
    shots.unqueued.each do |shot|
      CampaignMailer.delay.shot(shot)
      shot.touch(:queued_at)
    end
  end
end
