class AddSomeFieldsToShot < ActiveRecord::Migration
  def change
    add_column :shots, :bounce_at, :datetime
    add_column :shots, :deferred_at, :datetime
    add_column :shots, :dropped_at, :datetime
    add_column :shots, :click_at, :datetime
    add_column :shots, :open_at, :datetime
    add_column :shots, :spamreport_at, :datetime
    add_column :shots, :unsubscribe_at, :datetime
  end
end
