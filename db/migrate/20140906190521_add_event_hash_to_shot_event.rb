class AddEventHashToShotEvent < ActiveRecord::Migration
  def change
    add_column :shot_events, :event_hash, :hstore, index: true, using: :gin
  end
end
