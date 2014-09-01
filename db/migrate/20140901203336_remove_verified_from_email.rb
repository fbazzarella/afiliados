class RemoveVerifiedFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :verified, :boolean
  end
end
