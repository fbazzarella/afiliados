class AddEmailsCountToList < ActiveRecord::Migration
  def change
    add_column :lists, :emails_count, :integer, default: 0
  end
end
