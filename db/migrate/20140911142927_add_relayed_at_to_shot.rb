class AddRelayedAtToShot < ActiveRecord::Migration
  def change
    add_column :shots, :relayed_at, :datetime
  end
end
