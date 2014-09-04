class RenameVerifiedAtToBouncedAtOnEmail < ActiveRecord::Migration
  def change
    rename_column :emails, :verified_at, :bounced_at
  end
end
