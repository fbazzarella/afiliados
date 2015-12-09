class RenameListImportsToLists < ActiveRecord::Migration
  def change
    rename_table :list_imports, :lists
  end
end
