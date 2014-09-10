class AddSubjectToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :subject, :string
  end
end
