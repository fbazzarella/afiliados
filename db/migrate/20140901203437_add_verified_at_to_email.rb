class AddVerifiedAtToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :verified_at, :datetime
  end
end
