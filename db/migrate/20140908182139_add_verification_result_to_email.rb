class AddVerificationResultToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :verification_result, :string
  end
end
