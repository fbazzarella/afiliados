class ShotEvent < ActiveRecord::Base
  belongs_to :shot

  store_accessor :event_hash

  validates :shot_id, :service, :event, :event_hash, presence: true
end
