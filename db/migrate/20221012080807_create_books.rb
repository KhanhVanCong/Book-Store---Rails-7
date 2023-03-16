class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.boolean :is_featured, default: false

      t.timestamps
    end
  end
end
