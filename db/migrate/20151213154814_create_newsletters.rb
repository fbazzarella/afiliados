class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :from
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
