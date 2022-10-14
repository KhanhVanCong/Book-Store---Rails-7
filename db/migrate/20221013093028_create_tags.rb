class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.integer :books_count, default: 0

      t.timestamps
    end
  end
end
