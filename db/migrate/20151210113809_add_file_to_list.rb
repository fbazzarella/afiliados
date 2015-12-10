class AddFileToList < ActiveRecord::Migration
  def change
    add_column :lists, :file, :string
  end
end
