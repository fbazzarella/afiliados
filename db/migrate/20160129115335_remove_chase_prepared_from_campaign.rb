class RemoveChasePreparedFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :chase_prepared, :boolean, default: false
  end
end
