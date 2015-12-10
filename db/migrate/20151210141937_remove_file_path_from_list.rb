class RemoveFilePathFromList < ActiveRecord::Migration
  def change
    remove_column :lists, :file_path
  end
end
