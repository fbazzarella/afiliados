class CreateListImports < ActiveRecord::Migration
  def change
    create_table :list_imports do |t|
      t.string :file_path

      t.timestamps null: false
    end
  end
end
