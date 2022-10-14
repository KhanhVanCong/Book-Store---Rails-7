class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :books_count, default: 0

      t.timestamps
    end
  end
end
