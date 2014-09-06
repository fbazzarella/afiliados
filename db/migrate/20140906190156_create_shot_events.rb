class CreateShotEvents < ActiveRecord::Migration
  def change
    create_table :shot_events do |t|
      t.references :shot, index: :true
      t.string :service
      t.string :event

      t.timestamps
    end
  end
end
