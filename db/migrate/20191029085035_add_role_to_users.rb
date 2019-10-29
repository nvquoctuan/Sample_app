class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :numeric, default: 3
  end
end
