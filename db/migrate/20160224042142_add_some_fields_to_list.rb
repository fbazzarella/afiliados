class AddSomeFieldsToList < ActiveRecord::Migration
  def change
    add_column :lists, :valids_count,   :integer, default: 0
    add_column :lists, :invalids_count, :integer, default: 0
    add_column :lists, :unknowns_count, :integer, default: 0
  end
end
