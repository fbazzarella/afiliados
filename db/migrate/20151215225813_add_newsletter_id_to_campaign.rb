class AddNewsletterIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :newsletter_id, :integer, index: true
  end
end
