class RemoveFileNameFromImportError < ActiveRecord::Migration
  def change
    remove_column :import_errors, :file_name, :string
  end
end
