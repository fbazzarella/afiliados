class Campaign < ActiveRecord::Base
  belongs_to :newsletter

  has_many :shots, dependent: :destroy
  has_many :list_items, through: :shots

  validates :name, presence: true

  def prepare_chase!(list_ids)
    delay.increase_chase(list_ids)
    self
  end

  # def recover_chase!
  #   unless Sidekiq::Queue.new('default').any?
  #     delay.recover_chase
  #   end
  # end

  def chase!
    delay.chase
  end

  private

  def increase_chase(list_ids)
    list_ids.each do |list_id|
      List.find(list_id).list_items.valid.each do |list_item|
        shots.create(list_item_id: list_item.id)
      end
    end

    update_attribute(:chase_prepared, true)
  end

  # def decrease_chase(nof)
  #   while shots.unqueued.count > nof - shots.queued.count and shots.unqueued.count > 0
  #     shots.unqueued.last.delete
  #   end
  # end

  # def recover_chase
  #   shots.queued.unrelayed.update_all(queued_at: nil)
  # end

  def chase
    shots.unqueued.each(&:shoot!)
  end
end
