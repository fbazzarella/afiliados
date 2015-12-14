class RemoveEmailIdFromShot < ActiveRecord::Migration
  def change
    remove_column :shots, :email_id, :integer, index: true
  end
end
