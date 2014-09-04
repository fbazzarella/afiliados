class RemoveSomeFieldsFromShot < ActiveRecord::Migration
  def change
    remove_column :shots, :opened_at, :datetime
    remove_column :shots, :unsubscribed_at, :datetime
  end
end
