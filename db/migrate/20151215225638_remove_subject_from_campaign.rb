class RemoveSubjectFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :subject, :string
  end
end
