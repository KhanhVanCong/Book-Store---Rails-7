class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.string :facebook_link
      t.string :instagram_link
      t.string :google_plus_link
      t.string :twitter_link
      t.integer :books_count, default: 0

      t.timestamps
    end
  end
end
