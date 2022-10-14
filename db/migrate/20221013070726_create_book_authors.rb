class CreateBookAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :book_authors do |t|
      t.integer :book_id, null: false
      t.integer :author_id, null: false

      t.timestamps
    end

    add_foreign_key :book_authors, :books
    add_foreign_key :book_authors, :authors
    add_index :book_authors, :book_id
    add_index :book_authors, :author_id
    add_index :book_authors, [:book_id, :author_id], unique: true
  end
end
