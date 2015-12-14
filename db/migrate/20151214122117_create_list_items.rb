class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.references :list, index: true
      t.references :email, index: true

      t.timestamps null: false
    end
  end
end
