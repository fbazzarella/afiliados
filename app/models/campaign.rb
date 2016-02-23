class Campaign < ActiveRecord::Base
  belongs_to :newsletter

  has_many :shots, dependent: :nullify
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
    ar = ActiveRecord::Base.connection

    list_ids.each do |list_id|
      list = List.find(list_id)

      first_id = list.list_items.first.id
      last_id  = list.list_items.last.id

      for list_item_id in first_id..last_id do
        begin
          ar.execute %Q(
            INSERT INTO shots (campaign_id, list_item_id, created_at, updated_at)
            VALUES ('#{self.id}', '#{list_item_id}', '#{Time.now}', '#{Time.now}')
          )

          increment!(:reach)
        rescue Exception
        end
      end
    end

    update_attribute(:status, 'Pronta para Disparar')
  end

  def chase
    first_id = shots.unqueued.first.id
    last_id  = shots.unqueued.last.id

    for shot_id in first_id..last_id do
      Shot.find(shot_id).shoot!
    end
  end
end
