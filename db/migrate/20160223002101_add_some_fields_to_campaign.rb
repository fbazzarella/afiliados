class AddSomeFieldsToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :reach,        :integer, default: 0
    add_column :campaigns, :sent,         :integer, default: 0
    add_column :campaigns, :delivered,    :integer, default: 0
    add_column :campaigns, :opened,       :integer, default: 0
    add_column :campaigns, :clicked,      :integer, default: 0
    add_column :campaigns, :unsubscribed, :integer, default: 0
  end
end
