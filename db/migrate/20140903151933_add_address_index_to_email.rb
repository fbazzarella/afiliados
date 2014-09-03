class AddAddressIndexToEmail < ActiveRecord::Migration
  def change
    add_index :emails, :address
  end
end
