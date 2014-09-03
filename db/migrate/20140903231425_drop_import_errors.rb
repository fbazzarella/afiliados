class DropImportErrors < ActiveRecord::Migration
  def change
    drop_table :import_errors do |t|
      t.string :file_name
      t.integer :line_number
      t.string :line_string
      t.string :error_messages

      t.timestamps
    end
  end
end
