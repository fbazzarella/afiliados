class AddSomeOtherFieldsToShot < ActiveRecord::Migration
  def change
    add_column :shots, :opened_at,       :datetime
    add_column :shots, :clicked_at,      :datetime
    add_column :shots, :unsubscribed_at, :datetime
  end
end
