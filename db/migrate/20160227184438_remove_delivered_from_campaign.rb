class RemoveDeliveredFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :delivered, :integer, default: 0
  end
end
