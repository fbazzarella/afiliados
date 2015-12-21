class AddImportFinishedToList < ActiveRecord::Migration
  def change
    add_column :lists, :import_finished, :boolean, default: false
  end
end
