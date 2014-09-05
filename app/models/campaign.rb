class Campaign < ActiveRecord::Base
  has_many :shots, dependent: :restrict_with_error
  has_many :emails, through: :shots

  validates :name, presence: true

  def prepare_chase!(nof)
    delay.increase_chase(nof) if nof > shots.count
    delay.decrease_chase(nof) if nof < shots.count
  end

  def chase!
    delay.chase
  end

  private

  def increase_chase(nof)
    email_count    = Email.count
    first_email_id = Email.first.id
    last_email_id  = Email.last.id

    while shots.count < nof and shots.count < email_count
      email_id = rand(first_email_id..last_email_id)
      shots.create(email: Email.where(id: email_id).first)
    end
  end

  def decrease_chase(nof)
    while shots.unqueued.count > nof - shots.queued.count and shots.unqueued.count > 0
      shots.unqueued.last.delete
    end
  end

  def chase
    shots.unqueued.each do |shot|
      CampaignMailer.delay.shot(shot)
      shot.touch(:queued_at)
    end
  end
end
