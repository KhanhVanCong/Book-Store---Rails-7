class AddRoleNameStatusToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :role, :string, limit: 100
    add_column :admins, :name, :string, limit: 100
    add_column :admins, :status, :string, limit: 100
  end
end
