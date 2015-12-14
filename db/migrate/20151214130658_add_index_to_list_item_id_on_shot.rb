class AddIndexToListItemIdOnShot < ActiveRecord::Migration
  def change
    add_index :shots, [:list_item_id], name: 'index_shots_on_list_item_id', using: :btree
  end
end
