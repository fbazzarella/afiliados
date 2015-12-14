class AddListItemIdToShot < ActiveRecord::Migration
  def change
    add_column :shots, :list_item_id, :integer, index: true
  end
end
