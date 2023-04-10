class CreateOrderBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :order_books do |t|
      t.references :order, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.string :book_title
      t.decimal :price_per_unit
      t.integer :quantity

      t.timestamps
    end

    add_index :order_books, [:order_id, :book_id], unique: true
  end
end
