class Campaign < ActiveRecord::Base
  belongs_to :newsletter

  has_many :shots, dependent: :destroy
  has_many :list_items, through: :shots

  validates :name, presence: true

  def prepare_chase!(list_ids)
    delay.increase_chase(list_ids)
    self
  end

  def chase!
    delay.chase

    update_attribute(:status, 'Disparando')
  end

  private

  def increase_chase(list_ids)
    list_ids.each do |list_id|
      list = List.find(list_id)

      list.list_items.find_each do |list_item|
        shots.create(list_item_id: list_item.id)
      end
    end

    update_attribute(:status, 'Pronta para Disparar')
  end

  def chase
    shots.unqueued.find_each(&:shoot!)
  end
end
