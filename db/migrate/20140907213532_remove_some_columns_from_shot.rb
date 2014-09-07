class RemoveSomeColumnsFromShot < ActiveRecord::Migration
  def change
    remove_column :shots, :delivered_at, :datetime
    remove_column :shots, :bounce_at, :datetime
    remove_column :shots, :deferred_at, :datetime
    remove_column :shots, :dropped_at, :datetime
    remove_column :shots, :click_at, :datetime
    remove_column :shots, :open_at, :datetime
    remove_column :shots, :spamreport_at, :datetime
    remove_column :shots, :unsubscribe_at, :datetime
  end
end
