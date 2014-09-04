class RemoveAddressIndexFromEmail < ActiveRecord::Migration
  def change
    remove_index :emails, :address
  end
end
