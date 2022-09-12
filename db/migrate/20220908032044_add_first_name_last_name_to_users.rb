class AddFirstNameLastNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string, limit: 50, null: false, default: ""
    add_column :users, :last_name, :string, limit: 50, null: false, default: ""
  end
end
