class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots do |t|
      t.references :email, index: true
      t.references :campaign, index: true
      t.datetime :queued_at
      t.datetime :delivered_at
      t.datetime :opened_at
      t.datetime :unsubscribed_at

      t.timestamps
    end
  end
end
