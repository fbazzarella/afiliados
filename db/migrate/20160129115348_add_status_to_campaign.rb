class AddStatusToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :status, :string, default: 'Preparando'
  end
end
