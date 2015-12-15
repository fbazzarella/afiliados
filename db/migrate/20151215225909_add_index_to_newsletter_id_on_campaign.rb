class AddIndexToNewsletterIdOnCampaign < ActiveRecord::Migration
  def change
    add_index :campaigns, [:newsletter_id], name: 'index_campaigns_on_newsletter_id', using: :btree
  end
end
