class RemoveBouncedAtFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :bounced_at, :datetime
  end
end
