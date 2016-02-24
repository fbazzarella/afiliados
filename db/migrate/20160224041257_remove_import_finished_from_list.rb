class RemoveImportFinishedFromList < ActiveRecord::Migration
  def change
    remove_column :lists, :import_finished, :boolean, default: false
  end
end
