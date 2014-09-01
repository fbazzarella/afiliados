class AddFileNameToImportError < ActiveRecord::Migration
  def change
    add_column :import_errors, :file_name, :string
  end
end
