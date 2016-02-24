class AddStatusToList < ActiveRecord::Migration
  def change
    add_column :lists, :status, :string, default: 'Importando'
  end
end
