class AddChasePreparedToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :chase_prepared, :boolean, default: false
  end
end
